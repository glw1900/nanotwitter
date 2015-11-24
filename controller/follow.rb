get '/users/:username/following' do
  username = params[:username]
  user_id = User.find_by(username: username).id
  @parameters = {}
  @parameters[:logged_user_profile] = get_user_profile(user_id)
  @parameters[:users_list] = get_following(user_id)
  erb :follow
end

get '/users/:username/followers' do
  username = params[:username]
  user_id = User.find_by(username: username).id
  @parameters = {}
  @parameters[:logged_user_profile] = get_user_profile(user_id)
  @parameters[:users_list] = get_followers(user_id)
  erb :follow
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
  follow = Follow.new()
  follow.follower_id = params[:follower_id]
  follow.followee_id = params[:followee_id]
  viewed_username = User.find_by(id: params[:followee_id]).username
  if follow.save
    response["successfully_add_follow"] = "true"
    redirect '/users/' + viewed_username
  else
    "error when creating follow"
  end
end

post '/delete/follow' do
  #using name to destroy follow
  follower_id = params[:follower_id]
  followee_id = params[:followee_id]
  viewed_username = User.find_by(id: followee_id).username
  follow = Follow.find_by(followee_id: followee_id, follower_id: follower_id)
  if follow != nil
    follow.destroy
    response["successfully_deleted"] = "true"
    'unfollow success' + viewed_username
  else
    "ooooooooooooops, you've never been a fan, are you?"
  end
  redirect '/users/' + viewed_username
end