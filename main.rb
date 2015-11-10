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
set :environment, :production
enable :sessions
set :public_folder, File.dirname(__FILE__)+'/bootstrap-3.3.5-dist'
require 'pry-byebug'

get '/loaderio-e31204017626d3e3dbf093a153b06bd3/' do
  'loaderio-e31204017626d3e3dbf093a153b06bd3'
end


get '/' do
  @parameters = {}
  @parameters["unlogged_twitter_list"] = first_50_tweets_lst
  erb :home
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
