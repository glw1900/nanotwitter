require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './models/c_mention'        #Model class
require './models/comment'
require './models/favorite'
require './models/follow'
require './models/hash_tag'
require './models/message'
require './models/t_mention'
require './models/tag'
require './models/user'
require './models/tweet'
require 'pry-byebug'


get '/' do
  erb :homepage
end

get '/signup' do
  erb :sign_up
end

post '/user/submit' do
  @user = User.new(params[:user])
  username = @user.username
  # username = params[:user][:username]
  if @user.save
    redirect_string = '/user/' + username
    redirect redirect_string
  end
end

get '/user/:username' do
  @users = User.all

   #"#{params['username']}"
  erb :display
end
