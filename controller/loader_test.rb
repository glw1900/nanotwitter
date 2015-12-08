require 'faker'
require 'redis'
require 'json'
$redis = Redis.new(:url => "redis://redistogo:6089d2a4552e7700e65eebca0fdbca63@panga.redistogo.com:9792")


get '/user/testuser' do
  logged_username = "testuser"
  testuser = User.find_by(username: logged_username)
  if testuser != nil
    logged_id = testuser.id
    @parameters = {}
    if($redis.get("test_user_timeline_change") == "true" or $redis.get("test_user_timeline_change") == nil)
      @parameters = get_time_line(logged_id)
      $redis.set("test_user_timeline", @parameters.to_json)
      $redis.set("test_user_timeline_change", "false")
    else
      @parameters = JSON.parse($redis.get("test_user_timeline").gsub('=>', ':'))
    end
  else
    "testuser does not exist"
  end
  erb :timeline
end


post '/user/testuser/tweet' do
  logged_username = "testuser"
  testuser = User.find_by(username: logged_username)
  if testuser != nil
    logged_id = testuser.id
    return_message = {}
    tweet = {}
    tweet["content"] = Faker::Bitcoin.address
    tweet["media_url"] = "http://www.cats.org.uk/uploads/images/pages/photo_latest14.jpg"
    tweet["retweet_id"] = nil
    tweet["user_id"] = logged_id
    tweet["pub_time"] = nil
    newest_50_queue = "newest50queue"
    @new_tweet = Tweet.new(tweet)
    if @new_tweet.save!
      $redis.set("test_user_timeline_change", "true")
      h = sql_to_hash(@new_tweet, false)
      h["by_user"] = logged_username
      $redis.rpush(newest_50_queue, h.to_json)
      $redis.lpop(newest_50_queue)
      response["posted_tweet_id"] = "#{@new_tweet.id}"
      response["successfully_posted"] = "true"
      timelineOfB = "timelineOf" + tweet["user_id"].to_s
      if($redis.exists(timelineOfB))
        $redis.rpush(timelineOfB, h.to_json)
      end
    end
    "successful"
  else
    "testuser does not exist"
  end
end
