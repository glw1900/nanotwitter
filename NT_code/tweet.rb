
post "/create/tweet" do
  tweet = {}
  tweet[:content] = params[:tweet]
  tweet[:media_url] = nil
  tweet[:retweet_id] = nil
  tweet[:user_id] = User.find_by(username: session["username"]).id
  tweet[:pub_time] = nil

  @new_tweet = Tweet.new(tweet)
  if @new_tweet.save
    redirect '/timeline'
  end
end