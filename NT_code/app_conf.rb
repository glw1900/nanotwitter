get '/follow' do
  erb :personpage
end

post '/user/follow' do
  @follow = Follow.new(params[:follow])
  if @follow.save
    username = params[:follow][:follower]
    redirect '/follow/' + username
  end
end

get '/follow/:username' do
  username = params[:username]
  @follow_users = Follow.where("follower" : username)
end
