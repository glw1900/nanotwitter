def create_tweet(params)
  return_message = {}
  tweet = {}
  tweet["content"] = params[:content]
  tweet["media_url"] = params[:media_url]
  tweet["retweet_id"] = 0
  tweet["user_id"] = User.find_by(username: params["username"]).id
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
  end
end

post "/create/tweet" do
  create_tweet(params)
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
