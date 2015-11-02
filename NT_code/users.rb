#go to the person page of some one
get '/users/:username' do
  if User.find_by(username: params[:username]).nil?
    @mode = -1
  else
    @follow_from_id = User.find_by(username: session[:username]).id
    @follow_to_id = User.find_by(username: params[:username]).id
    @pageuser = params[:username]
    if @follow_from_id == @follow_to_id
      #user is checiing his or her own page
      @mode = 0
    elsif Follow.where(follower_id: @follow_from_id, followee_id: @follow_to_id).size > 0
      #alreadt followed, show a button to unfollow
      @mode = 1
    else
      #show a follow button
      @mode = 2
    end
  end
  @uname = params[:username]
  user_id = User.find_by(username: @uname).id
  @tweet_list = Tweet.where(user_id: user_id)
  erb :personpage2
end

post '/create/user' do
  @user = User.new(params)
  if @user.save
    redirect '/signin'
  end
end

post '/delete/user/:username' do
  user = User.find_by(username: params[:username])
  if user != nil
    user.destroy
  end
end