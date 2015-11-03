
post "/create/tweet" do
  return_message = {}
  tweet = {}
  tweet["content"] = params[:content]
  tweet["media_url"] = params[:media_url]
  tweet["retweet_id"] = params[:retweet_id]
  tweet["user_id"] = User.find_by(username: params["username"]).id
  tweet["pub_time"] = nil
  @new_tweet = Tweet.new(tweet)
  if @new_tweet.save
    # response["posted_tweet_id"] = @new_tweet.id
    # response["successfully_posted"] = true
    redirect '/timeline'
  end
end


post "/delete/tweet" do
  tweet_id = params["tweet_id"]
  @tweet_to_delete = Tweet.find_by(id: tweet_id)
  if @tweet_to_delete != nil
    @tweet_to_delete.destroy
    response["successfully_deleted"] = true
  else
    puts "Warning! tweet_id #{tweet_id} does not exist, no need to delete it."
  end
end
