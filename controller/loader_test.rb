get '/user/testuser' do
  logged_username = "testuser"
  testuser = User.find_by(username: logged_username)
  if testuser != nil
    logged_id = testuser.id
  else
    "testuser does not exist"
  end
  @parameters = {}
  @parameters = get_time_line(logged_id)
  erb :timeline
end



post '/user/testuser/tweet' do
  logged_username = "testuser"
  testuser = User.find_by(username: logged_username)
  if testuser != nil
    logged_id = testuser.id

    return_message = {}
    tweet = {}
    tweet["content"] = "a fake tweet"
    tweet["media_url"] = "http://www.cats.org.uk/uploads/images/pages/photo_latest14.jpg"
    tweet["retweet_id"] = 0
    tweet["user_id"] = logged_id
    tweet["pub_time"] = nil
    newest_50_queue = "newest50queue"
    @new_tweet = Tweet.new(tweet)
    if @new_tweet.save!
      h = sql_to_hash(@new_tweet, false)
      h["by_user"] = params["username"]
      $redis.rpush(newest_50_queue, h.to_json)
      $redis.lpop(newest_50_queue)
      response["posted_tweet_id"] = "#{@new_tweet.id}"
      response["successfully_posted"] = "true"
      timelineOfB = "timelineOf" + tweet["user_id"].to_s
      if($redis.exists(timelineOfB))
        $redis.rpush(timelineOfB, h.to_json)
      end
    end
  else
    "testuser does not exist"
  end
end
