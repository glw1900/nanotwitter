require "pry-byebug"
require "redis"
$redis = Redis.new(:url => "redis://redistogo:6089d2a4552e7700e65eebca0fdbca63@panga.redistogo.com:9792")
def auth(user)
  username = user["username"]
  password = user["password"]
  u = User.find_by(username: username)
  if u.nil?
    return false
  end
  if u.password == password
    return true
  end
  return false
end

def check(user)
  username_to_create = user[:username]
  if(User.find_by(username: username_to_create) != nil)
    return "name already registered"
  end
  password = user["password"]
  re_password = user["re_password"]
  user["regist_date"] = nil
  if password == re_password
    user.delete("re_password")
    return user
  else
    return "passwords do not match"
  end
end

def how_many_do_i_follow(user_id)
  rt = Follow.select(:followee_id).where("follower_id = #{user_id}")
  return rt.count
end

def how_many_follow_me(user_id)
  rt = Follow.select(:follower_id).where("followee_id = #{user_id}")
  return rt.count
end

def tweet_array_to_hash(records_array, logged)
  rt = Array.new
  records_array.each do |tw|
    t = sql_to_hash(tw, logged)
    rt << t
  end
  rt.sort { |x, y| x["time"] <=> y["time"] }
  rt = rt.reverse
  return rt
end


def sql_to_hash(tw, logged)
  t = Hash.new()
  t["text"] = tw["content"]
  t["id"] = tw["id"]
  t["time"] = tw["created_at"]
  t["by_user"] = tw["username"]
  t["retweet_id"] = tw["retweet_id"]
  t["abbreviation"] = nil
  if tw["retweet_id"] != nil
    retweet_user_id = Tweet.find_by(id: tw["retweet_id"]).user_id
    t["retweet_user_name"] = User.find_by(id: retweet_user_id).username
    t["abbreviation"] = top_n_word_from_tweet(tw["retweet_id"])
  end
  t["comment"] = get_comment_list(tw["id"])
  # t["favored"] = 
  if logged
    #fake data
    t["has_this_user_favorited_this_tweet"] = false
  end
  return t
end



def top_n_word_from_tweet(tweet_id)

  if Tweet.find_by(id: tweet_id).nil?
    return ""
  else
    truecontent = Tweet.find_by(id: tweet_id).content
    return top_n_word(truecontent,12)
  end
  content = Tweet.find_by(id: tweet_id).content
  return top_n_word(content, 12)

end

# def sql_to_hash_single(tw, logged)
#   t = Hash.new()
#   t["text"] = tw["content"]
#   t["time"] = tw["created_at"]
#   t["by_user"] = tw["username"]
#   # below is made up
#   t["favourite_number"] = 10
#   t["comment"] = get_comment_list()
#   if logged
#     #fake data
#      t["has_this_user_favorited_this_tweet"] = false
#   end
#   return t
# end

def first_50_tweets_lst
  # return an array of hash
  newest_50_queue = "newest50queue"
  if(!$redis.exists(newest_50_queue) || ($redis.llen(newest_50_queue) <= 40))
    sql = "SELECT T.id, T.content, T.created_at, T.retweet_id, U.username FROM tweets AS T, users AS U WHERE T.user_id = U.id ORDER BY T.created_at DESC LIMIT 50"
    records_array =  ActiveRecord::Base.connection.execute(sql)
    rt = tweet_array_to_hash(records_array, false)
    rt.each do |tweet|
      $redis.rpush(newest_50_queue, tweet.to_json)
    end
  end

  array_of_jsons = $redis.lrange( "newest50queue",0,49)
  rt_array = Array.new
  array_of_jsons.each do |js|
      rt_array << JSON.parse(js)
  end

  return rt_array
end


def first_50_tweets_lst_no_redis
  /#
  # return an array of hash
  #/
  newest_50_queue = "newest50queue"
  # if first_50_queue is empty
  #/
    sql = "SELECT T.id, T.content, T.created_at, T.retweet_id, U.username FROM tweets AS T, users AS U WHERE T.user_id = U.id ORDER BY T.created_at DESC LIMIT 50"
    records_array =  ActiveRecord::Base.connection.execute(sql)
    rt = tweet_array_to_hash(records_array, false)
    rt.each do |tweet|
      $redis.rpush(newest_50_queue, tweet.to_json)
    end
  array_of_jsons = $redis.lrange( "newest50queue",0,49)
  rt_array = Array.new
  array_of_jsons.each do |js|
      rt_array << JSON.parse(js)
  end

  return rt_array
end

def get_time_line_tweets(user_id)
  /#
  return an array of hash
  #/
  sql = "SELECT T.id, T.content, T.created_at, T.retweet_id, U.username FROM tweets AS T, users AS U WHERE T.user_id = U.id AND ( (T.user_id = #{user_id}) OR (T.user_id IN
  (SELECT DISTINCT followee_id FROM follows AS F WHERE F.follower_id = #{user_id})) ) ORDER BY T.created_at "
  records_array = ActiveRecord::Base.connection.execute(sql)
  rt = tweet_array_to_hash(records_array, true)
  return rt
end

def get_user_profile(user_id)
  image_url = "https://upload.wikimedia.org/wikipedia/commons/f/f6/Barack_Obama_and_Bill_Clinton_profile.jpg"
  rt = {}
  rt["username"] = User.find_by(id: user_id).username
  rt["follower_id"] = user_id
  rt["profile_photo_url"] = image_url
  rt["follow_number"] = how_many_do_i_follow(user_id)
  rt["follower_number"] = how_many_follow_me(user_id)
  return rt
end

def get_time_line(user_id)
  rt = {}
  rt["logged_user_profile"] = get_user_profile(user_id)
  rt["timeline_twitter_list"] = get_time_line_tweets(user_id)
  num = 0
  rt["timeline_twitter_list"].each do |tw|
    if tw["by_user"] == session["username"]
      num = num + 1
    end
  end
  rt["logged_user_profile"]["tweet_num"] = num
  return rt
end

# print check({:re_password=>"abc", :password=>"abc"})
def user_a_look_at_user_b_homepage_with_redis(user_a_id, user_b_id)

  timelineOfB = "timelineOf" + user_b_id.to_s

  if(!$redis.exists(timelineOfB))
    sql = "SELECT T.id, T.content, T.created_at, T.retweet_id, U.username FROM tweets AS T, users AS U WHERE T.user_id = U.id AND T.user_id = #{user_b_id} "
    records_array =  ActiveRecord::Base.connection.execute(sql)
    rt = tweet_array_to_hash(records_array, false)
    rt.each do |tweet|
      $redis.rpush(timelineOfB, tweet.to_json)
    end
  end
    tw_array = Array.new
    array_of_jsons = $redis.lrange(timelineOfB,0,-1)
    array_of_jsons.each do |js|
        tw_array << JSON.parse(js)
    end

    image_url = "https://upload.wikimedia.org/wikipedia/commons/f/f6/Barack_Obama_and_Bill_Clinton_profile.jpg"
    rt = {}
    rt["logged_user_profile"] = get_user_profile(user_a_id)
    rt["followee_id"] = user_b_id
    rt["homepage_tweet_list"] = tw_array
    rt["username"] = User.find_by(id: user_b_id).username
    rt["follow_number"] = how_many_do_i_follow(user_b_id)
    rt["follower_number"] = how_many_follow_me(user_b_id)
    mode = "user_viewing_self"
    if user_a_id != user_b_id
      follow_list = Follow.where(followee_id: user_b_id, follower_id: user_a_id)
      if follow_list.size() == 1
        mode = "user_viewing_followed"
      else
        mode = "user_viewing_unfollowed"
      end
    end
    rt["mode"] = mode
    return rt
end


def user_a_look_at_user_b_homepage(user_a_id, user_b_id)
  # TODO: MISS FAVOURITES, FOLLOW NUMBER, FOLLOWER NUMBER

  sql = "SELECT T.id, T.content, T.created_at, T.retweet_id, U.username FROM tweets AS T, users AS U WHERE T.user_id = U.id AND T.user_id = #{user_b_id} "
  records_array = ActiveRecord::Base.connection.execute(sql)
  tw_array = tweet_array_to_hash(records_array, true)

  image_url = "https://upload.wikimedia.org/wikipedia/commons/f/f6/Barack_Obama_and_Bill_Clinton_profile.jpg"
  rt = {}
  rt["logged_user_profile"] = get_user_profile(user_a_id)
  rt["followee_id"] = user_b_id
  rt["homepage_tweet_list"] = tw_array
  rt["username"] = User.find_by(id: user_b_id).username
  rt["follow_number"] = how_many_do_i_follow(user_b_id)
  rt["follower_number"] = how_many_follow_me(user_b_id)
  mode = "user_viewing_self"
  if user_a_id != user_b_id
    follow_list = Follow.where(followee_id: user_b_id, follower_id: user_a_id)
    if follow_list.size() == 1
      mode = "user_viewing_followed"
    else
      mode = "user_viewing_unfollowed"
    end
  end
  rt["mode"] = mode
  return rt
end

def get_following(user_id)
  sql = "SELECT U.username, F.created_at
        FROM users AS U, follows as F
        WHERE U.id = F.followee_id
        AND F.follower_id = #{user_id}"
  records_array = ActiveRecord::Base.connection.execute(sql)
  return create_user_ls_from_sql_result(records_array)
end

def get_followers(user_id)
  sql = "SELECT U.username, F.created_at
        FROM users AS U, follows as F
        WHERE U.id = F.follower_id
        AND F.followee_id = #{user_id}"
  records_array = ActiveRecord::Base.connection.execute(sql)
  return create_user_ls_from_sql_result(records_array)
end

def view_a_twitter(tweet_id)
  res = {}
  t = Tweet.find_by(id: tweet_id)
  res["id"] = tweet_id
  res["text"] = t.content
  res["time"] = t.created_at
  res["retweet_id"] = t.retweet_id
  res["user_id"] = t.user_id
  res["by_user"] = User.find_by(id: t.user_id).username
  res["abbreviation"] = top_n_word_from_tweet(t["retweet_id"])
  res["comment"] = get_comment_list(tweet_id)
  return res
end

def get_comment_list(tweet_id)
  sql = "SELECT u.username,c.content, c.created_at
        FROM users AS u, comments AS c
        WHERE u.id = c.commenter_id
        AND c.tweet_id = #{tweet_id}
        ORDER BY c.created_at DESC"
  records_array = ActiveRecord::Base.connection.execute(sql)
  return comment_arr_to_hash(records_array)
end

def comment_arr_to_hash(comments_array)
  arr = Array.new()
  comments_array.each do |comment|
    h = Hash.new()
    h["commenter_name"] = comment["username"]
    h["content"] = comment["content"]
    h["created_at"] = comment["created_at"]
    arr << h
  end
  return arr
end


def create_user_ls_from_sql_result(arr)
  ls = []
  image_url = "http://vignette1.wikia.nocookie.net/webarebears/images/d/d6/Bear_stack.jpg/revision/latest?cb=20150706002256"
  arr.each do |user|
    user_hash = {}
    user_hash["username"] = user[0]
    user_hash["followed_at_time"] = user[1]
    user_hash["profile_photo_url"] = image_url
    ls.push(user_hash)
  end
  return ls
end

#======================for test interface

def make_follower(followee_id, num)
  sample_ids = User.pluck(:id).sample(num)
  i = 0
  while(i < num) do
    if Follow.find_by(follower_id: sample_ids[i], followee_id: followee_id).nil? and sample_ids[i] != followee_id
      Follow.create(follower_id: sample_ids[i], followee_id: followee_id)
    end
    i = i + 1
  end
end

def make_fake_tweets(user_name, num)
# binding.pry
  testuser_id = User.find_by(username: "testuser")
  values = []
  columns = [:tweet_id, :content]
# binding.pry
  i = 0
  while( i < num) do
      values.push [testuser_id, Faker::Lorem.sentence]
    end

# binding.pry
    Tweet.bulk_insert(values, columns)
#    binding.pry
end

def top_n_word(str,n)
  str.split(/\s+/, n+1)[0...n].join(' ')
end


def user_a_favor_tweet_list(user_id)
    sql = "SELECT T.id, T.content,T.retweet_id, F.created_at, T.user_id, U.username
        FROM tweets AS T, favorites as F, users AS U
        WHERE T.id = F.tweet_id
        AND T.user_id = U.id
        AND F.user_id = #{user_id}
        ORDER BY F.created_at DESC"
  records_array = ActiveRecord::Base.connection.execute(sql)
  return tweet_array_to_hash(records_array, true)
end
