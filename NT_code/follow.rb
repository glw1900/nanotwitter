get '/user/:username/following' do
  @username = params[:username]
  #get the id of the current pageuser
  user_id = User.find_by(username: @username).id
  follow_ids = Follow.where(follower_id: user_id)
  # binding.pry
  @follow_users = []
  follow_ids.each do |follow|
    fname = User.find_by(id: follow.followee_id)
    @follow_users << fname
  end
  erb :followlist
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
  @follow.follower_id = params[:follow_from_id]
  @follow.followee_id = params[:follow_to_id]
  # binding.pry
  if @follow.save
    username = User.find_by(id: params[:follow_from_id]).username
    redirect '/follow/' + username
  else
    "error when creating follow"
  end
end

post '/delete/follow' do
  follow = Follow.find_by(followee_id: params[:follow_to_id], follower_id: params[:follow_from_id])
  follow_to_name = User.find_by(id: params[:follow_to_id]).username
  if follow != nil
    follow.destroy
    'unfollow success' + follow_to_name
  else
    "ooooooooooooops, you've never been a fan, are you?"
  end
  redirect '/users/' + follow_to_name
end