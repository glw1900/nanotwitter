get '/api' do
  first_50_tweets_lst.to_json
end

get '/api/users/:username' do
  #add follower_id and followee_id to @parameters
  logged_username = params[:logged_username]
  logged_id = User.find_by(username: logged_username).id
  look_at_username = params[:username]
  look_at_user_id = User.find_by(username: look_at_username).id
  @parameters = user_a_look_at_user_b_homepage_with_redis(logged_id, look_at_user_id)
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

<<<<<<< HEAD

post "/signin" do
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

||||||| merged common ancestors
=======
<<<<<<< HEAD


post "/api/signin" do
  response_body = Hash.new
  @tring_logging_in = params[:user]
  if @tring_logging_in.is_a? String
    @tring_logging_in = JSON.parse(@tring_logging_in.gsub('=>', ':'))
  end
  if auth(@tring_logging_in)
    username = @tring_logging_in["username"]
    session["username"] = username
    redirect '/timeline'
    response_body["login_ok"] = "ok"
  else
    "Wrong Password"
  end
end
=======
>>>>>>> 70d5960469b3ee3ea5b22f765c4586620b30d5f5
>>>>>>> 6f489698c7db600e91e7386ab4fc27710ade5667
