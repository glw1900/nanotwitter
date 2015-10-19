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
require './process'
enable :sessions
require 'pry-byebug'


get '/' do
  erb :homepage
end

get '/signup' do  
  erb :sign_up
end

post '/user/submit_regis' do
  @user = User.new(params[:user])
  username = @user.username
  if @user.save
    # redirect_string = '/user/' + username
    # redirect redirect_string
    redirect '/'
  end
end

post "/user/submit" do
  @tring_logging_in = params[:user]
  if auth(@tring_logging_in)
    email = @tring_logging_in["email"]
    session["email"] = email
    redirect '/user/' + email
  else
    "Wrong Password"
  end
end

post "/user/submit_twitter" do
  @tweet = 
end

get '/user/:email' do
  # username = params[:email]
  if !session["email"].nil?
    email = session["email"]
    "#{email}"
    # erb :timeline
  end
end





