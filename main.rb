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

get '/loaderio-ed1bbf67a573c43a29c3a8ceeb1fb606/' do
  'loaderio-ed1bbf67a573c43a29c3a8ceeb1fb606'
end

get 'loaderio-b025f3b735c868b05d4c58827006dd6e/' do
  'loaderio-b025f3b735c868b05d4c58827006dd6e'
end

get '/' do
  @parameters = {}
  @parameters["unlogged_twitter_list"] = first_50_tweets_lst
  erb :home
end


get '/mytest/:username' do
  logged_username = session[:username]
  logged_id = User.find_by(username: logged_username).id
  look_at_username = params[:username]
  look_at_user_id = User.find_by(username: look_at_username).id
  @parameters = user_a_look_at_user_b_homepage_with_redis(logged_id, look_at_user_id)
  @parameters.to_json
end

#to clear redis if any format changes in data
get '/clearredis' do
  $redis.flushdb
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
  response["status"] = "true"
  redirect "/"
end

post "/signin" do
  @tring_logging_in = params[:user]
  if @tring_logging_in.is_a? String
    @tring_logging_in = JSON.parse(@tring_logging_in.gsub('=>', ':'))
  end
  if auth(@tring_logging_in)
    username = @tring_logging_in["username"]
    session["username"] = username
    binding.pry
    redirect '/timeline'
    response["login_ok"] = "ok"
  else
    "Wrong Password"
  end
end
