
post "/create/tweet" do
  return_message = {}
  tweet = {}
  tweet["content"] = params[:content]
  tweet["media_url"] = params[:media_url]
  tweet["retweet_id"] = 0
  tweet["user_id"] = User.find_by(username: params["username"]).id
  tweet["pub_time"] = nil
  
  
  
  /#
  {
    "text":"Fugiat quas et et aut omnis voluptatum.","time":"2015-11-21 12:28:18","by_user":"username94","favourite_number":10,"comment":{"commenter_name":"fake_name_1","content":"fake_content_2","time":"2007-10-23 22:15:15 UTC","reply_to":"fake_content_3"
  }
  #/
  
  # redis_tweet = {}
  # redis_tweet["text"] = params[:content]
  # redis_tweet["by_user"] = params[:user_id]
  # redis_tweet["favourite_number"] = 10
  # redis_tweet["comment"] = {"commenter_name" => "fake_name_1","content" => "fake_content_2","time" => "2007-10-23 22:15:15 UTC", "reply_to" => "fake_content_3" }
  
  newest_50_queue = "newest50queue"
  
  
  @new_tweet = Tweet.new(tweet)
  puts @new_tweet

  
  
  if @new_tweet.save!
    h = sql_to_hash(@new_tweet, false)
    h["by_user"] = params["username"]
    puts h
    $redis.rpush(newest_50_queue, h.to_json)
    $redis.lpop(newest_50_queue)
    response["posted_tweet_id"] = "#{@new_tweet.id}"
    response["successfully_posted"] = "true"
    redirect '/timeline'
  end
  redirect '/timeline'
end


post "/delete/tweet" do
  tweet_id = params["tweet_id"]
  @tweet_to_delete = Tweet.find_by(id: tweet_id)
  if @tweet_to_delete != nil
    @tweet_to_delete.destroy
    response["successfully_deleted"] = "true"
  else
    puts "Warning! tweet_id #{tweet_id} does not exist, no need to delete it."
  end
end
