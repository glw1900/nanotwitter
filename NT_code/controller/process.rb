require "pry-byebug"

def auth(user)
  username = user["username"]
  password = user["password"]
  u = User.find_by(username: username)
  # binding.pry
  if u.nil?
    return false
  end
  if u.password == password
    return true
  end
  return false
end

def check(user)
  password = user["password"]
  re_password = user["re_password"]
  user["regist_date"] = nil
  if password == re_password
    user.delete("re_password")
    return user
  else
    return nil
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
    t = Hash.new()
    t["text"] = tw["content"]
    t["time"] = tw["created_at"]
    t["by_user"] = tw["username"]
    # below is made up
    t["favourite_number"] = 10
    t["comment"] = Hash.new
    t["comment"]["commenter_name"] = "fake_name_1"
    t["comment"]["content"] = "fake_content_2"
    t["comment"]["time"] = "2007-10-23 22:15:15 UTC"
    t["comment"]["reply_to"] = "fake_content_3"
    if logged
      #fake data
       t["has_this_user_favorited_this_tweet"] = false
    end
    rt << t
  end
  rt.sort { |x, y| x["time"] <=> y["time"] }
  rt = rt.reverse
  return rt
end

def first_50_tweets_lst
  /#
  return an array of hash
  #/
  sql = "SELECT T.content, T.created_at, T.retweet_id, U.username FROM tweets AS T, users AS U WHERE T.user_id = U.id ORDER BY T.created_at DESC LIMIT 50"
  records_array = ActiveRecord::Base.connection.execute(sql)
  rt = tweet_array_to_hash(records_array, false)
  return rt
end

def get_time_line_tweets(user_id)
  /#
  return an array of hash
  #/
  
  
  sql = "SELECT T.content, T.created_at, T.retweet_id, U.username FROM tweets AS T, users AS U WHERE T.user_id = U.id AND ( (T.user_id = #{user_id}) OR (T.user_id IN 
  (SELECT DISTINCT followee_id FROM follows AS F WHERE F.follower_id = #{user_id})) ) ORDER BY T.created_at ASC"
  records_array = ActiveRecord::Base.connection.execute(sql)
  rt = tweet_array_to_hash(records_array, true)
  return rt
end

def get_user_profile(user_id)
  image_url = "https://upload.wikimedia.org/wikipedia/commons/f/f6/Barack_Obama_and_Bill_Clinton_profile.jpg"
  
  rt = {}
  rt["username"] = User.find_by(id: user_id).username
  rt["profile_photo_url"] = image_url
  rt["follow_number"] = how_many_do_i_follow(user_id)
  rt["follower_number"] = how_many_follow_me(user_id)
  return rt
end

def get_time_line(user_id)
  rt = {}
  rt["logged_user_profile"] = get_user_profile(user_id)
  rt["timeline_twitter_list"] = get_time_line_tweets(user_id)
  return rt
end

# print check({:re_password=>"abc", :password=>"abc"})

def user_a_look_at_user_b_homepage(user_a_id, user_b_id)
  # TODO: MISS FAVOURITES, FOLLOW NUMBER, FOLLOWER NUMBER
  sql = "SELECT T.content, T.created_at, T.retweet_id, U.username FROM tweets AS T, users AS U WHERE T.user_id = U.id AND T.user_id = #{user_b_id} "
  records_array = ActiveRecord::Base.connection.execute(sql)
  tw_array = tweet_array_to_hash(records_array, true)
  
  image_url = "https://upload.wikimedia.org/wikipedia/commons/f/f6/Barack_Obama_and_Bill_Clinton_profile.jpg"
  rt = {}
  rt["logged_user_profile"] = get_user_profile(user_a_id)
  rt["homepage_tweet_list"] = tw_array
  rt["username"] = User.find_by(id: user_b_id).username
  rt["follow_number"] = how_many_do_i_follow(user_b_id)
  rt["follower_number"] = how_many_follow_me(user_b_id)
  mode = "user_viewing_self"
  if user_a_id != user_b_id
    follow_list = Follow.where(followee_id: user_b_id, follower_id: user_a_id)
    if follow_list.size() == 1
      mode = "user_viewing_unfollowed"
    else
      mode = "user_viewing_followed"
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
