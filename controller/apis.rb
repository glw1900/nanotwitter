#api
get '/api/v1/tweet/:tweet_id' do
  t = Tweet.find_by(id: params[:tweet_id]).as_json
end

get '/api/v1/users/:id' do
  u = User.find_by(id:params[:id]).as_json
end

get '/api/v1/:num' do
  num = params[:num]
  first_50_tweets_lst[0..num].to_json
end

get '/api/v1/:id/tweets' do
  logged_username = params[:logged_username]
  logged_id = User.find_by(username: logged_username).id
  look_at_username = params[:username]
  look_at_user_id = User.find_by(username: look_at_username).id
  @parameters = user_a_look_at_user_b_homepage_with_redis(logged_id, look_at_user_id)["homepage_tweet_list"]
  @parameters.to_json
end

post '/api/create/follow' do
  parameters = {}
  follow = Follow.new()
  if(params[:follower_id] != nil)
    follow.follower_id = params[:follower_id]
  else
    follow.follower_id = User.find_by(username: params[:follower_name]).id
  end

  if(params[:followee_id] != nil)
    follow.followee_id = params[:followee_id]
  else
    follow.followee_id = User.find_by(username: params[:followee_name]).id
  end

  if params[:follower_name] != nil
    viewed_username = params[:follower_name]
  else
    viewed_username = User.find_by(id: params[:followee_id]).username
  end
  if follow.save
    parameters["status"] = "true"
  else
    parameters["status"] = "false"
  end
  parameters.to_json
end

post '/api/delete/follow' do
  #using name to destroy follow
  follower_id = User.find_by(username: params[:follower_name]).id
  followee_id = User.find_by(username: params[:followee_name]).id

  viewed_username = params[:followee_name]
  follow = Follow.find_by(followee_id: followee_id, follower_id: follower_id)
  parameters = {}
  if follow != nil
    follow.destroy
    parameters["status"] = "true"
  else
    parameters["status"] = "false"
  end
  parameters.to_json
end

get '/api/timeline/:username' do
  logged_username = params[:username]
  logged_id = User.find_by(username: logged_username).id
  @parameters = {}
  if !logged_username.nil?
    @parameters = get_time_line(logged_id)
  end
  @parameters.to_json
end

post "/api/signin" do
  @user = {}
  @user["username"] = params[:username]
  @user["password"] = params[:password]
  parameters = {}
  if auth(@user)
    parameters["status"] = "true"
  else
    parameters["status"] = "false"
  end
  parameters.to_json
end