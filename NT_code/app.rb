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
# require 'pry-byebug'


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
    username = @tring_logging_in["username"]
    session["username"] = username
    redirect '/user/timeline'
  else
    "Wrong Password"
  end
end

post "/user/submit_twitter" do
  tweet = {}
  tweet[:content] = params[:tweet]
  tweet[:media_url] = nil
  tweet[:retweet_id] = nil
  tweet[:user_id] = User.find_by(username: session["username"]).id
  tweet[:pub_time] = nil

  @new_tweet = Tweet.new(tweet)
  if @new_tweet.save
    redirect '/user/timeline'
  end
end

get '/user/timeline' do
  username = session[:username]
  user_id = User.find_by(username: username).id
  if !session["username"].nil?
    # username = session["username"]
    @tweet_list = Tweet.where(user_id: user_id)
    # if @tweet_list.nil?
    #   @tweet_list = ["this is a tweet"]
    # end
    erb :timeline
  end
end

get '/follow' do
  erb :personpage
end

post '/user/follow' do
  par = {}
  par[:follower_id] = User.find_by(username: params[:follow][:follower]).id
  par[:followee_id] = User.find_by(username: params[:follow][:followee]).id
  @follow = Follow.new(par)
  if @follow.save
    username = params[:follow][:follower]
    redirect '/follow/' + username
  else
    "wrong when creating follow"
  end
end

get '/follow/:username' do
  username = params[:username]
  user_id = User.find_by(username: username).id
  @follow_users = Follow.find_by(follower_id: user_id)
  

  if !@follow_users.is_a? Array
    @follow_users = [@follow_users]
  end
  erb :follow
end
