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
require './controller/require_rb'
require 'newrelic_rpm'
set :environment, :production
enable :sessions
set :public_folder, File.dirname(__FILE__)+'/bootstrap-3.3.5-dist'
require 'pry-byebug'

get '/loaderio-d3a485382ba9e01e149ff5b014cd52e3/' do
  'loaderio-d3a485382ba9e01e149ff5b014cd52e3'
end

get '/loaderio-f3cc423b8dcef53b6cafc74290cff52f/' do
  'loaderio-f3cc423b8dcef53b6cafc74290cff52f'
end

get '/' do
  @parameters = {}
  @parameters["unlogged_twitter_list"] = first_50_tweets_lst
  erb :home
end


get '/mytest' do
  logged_username = session[:username]
  logged_id = User.find_by(username: logged_username).id
  @parameters = {}
  if !session["username"].nil?
    @parameters = get_time_line(logged_id)
  end
  @parameters
end

get '/timeline' do
  logged_username = session[:username]
  logged_id = User.find_by(username: logged_username).id
  @parameters = {}
  if !session["username"].nil?
    @parameters = get_time_line(logged_id)
  end
  erb :timeline
end

get '/signup' do
  erb :regist
end

get '/signin' do
  erb :sign_in
end

get '/logout' do
  session["username"] = nil
  redirect "/"
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
