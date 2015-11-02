get '/users/:username/following' do
  username = params[:username]
  user_id = User.find_by(username: username).id
  @parameters = {}
  @parameters[:logged_user_profile] = get_user_profile(user_id)
  @parameters[:users_list] = get_following(user_id)
  erb :test
end

get '/users/:username/followers' do
  username = params[:username]
  user_id = User.find_by(username: username).id
  @parameters = {}
  @parameters[:logged_user_profile] = get_user_profile(user_id)
  @parameters[:users_list] = get_followers(user_id)
  erb :test
end

post '/create/user' do
  u = check(params[:user])
  if u
    @user = User.new(u)
    if @user.save
      redirect '/signin'
    end
  end
  "Password not match"
end

post "/signin" do
  @tring_logging_in = params[:user]
  if auth(@tring_logging_in)
    username = @tring_logging_in["username"]
    session["username"] = username
    redirect '/timeline'
  else
    "Wrong Password"
  end
end

post '/create/follow' do
  @follow = Follow.new()
  @follow.follower_id = params[:follower_id]
  @follow.followee_id = params[:followee_id]
  if @follow.save
    username = User.find_by(id: params[:follower_id]).username
    response["successfully_add_follow"] = true
    redirect '/follow/' + username
  else
    "error when creating follow"
  end
end

post '/delete/follow' do
  follow = Follow.find_by(followee_id: params[:followee_id], follower_id: params[:follower_id])
  follow_to_name = User.find_by(id: params[:followee_id]).username
  if follow != nil
    follow.destroy
    response["successfully_deleted"] = true
    'unfollow success' + follow_to_name
  else
    "ooooooooooooops, you've never been a fan, are you?"
  end
  redirect '/users/' + follow_to_name
end