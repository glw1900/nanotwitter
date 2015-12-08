#go to the person page of some one
$redis = Redis.new(:url => "redis://redistogo:6089d2a4552e7700e65eebca0fdbca63@panga.redistogo.com:9792")

get '/users/:username' do
  #add follower_id and followee_id to @parameters
  binding.pry
  if params[:username] == "testuser"
    redirect '/users/testuser'
  else
    logged_username = session[:username]
    logged_id = User.find_by(username: logged_username).id
    look_at_username = params[:username]
    look_at_user_id = User.find_by(username: look_at_username).id
    @parameters = user_a_look_at_user_b_homepage_with_redis(logged_id, look_at_user_id)
    erb :personpage
  end
end

post '/create/user' do
  user_checked = check(params)
  if user_checked.class == String
    redirect '/signup'
  end
  @user = User.new(user_checked)
  if @user.save
    response["successfully_sign_up"] = "true"
    redirect '/signin'
  end
end

post '/delete/user/:username' do
  user = User.find_by(username: params[:username])
  if user != nil
    user.destroy
    response["successfully_deleted"] = "true"
  end
end
