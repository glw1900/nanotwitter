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
  tweet[:user_id] = User.find_by(username: session["username"])
  tweet[:pub_time] = nil

  @new_tweet = Tweet.new(tweet)
  if @new_tweet.save
    redirect '/user/timeline'
  end

end

get '/user/timeline' do
  username = params[:username]
  if !session["username"].nil?
    # username = session["username"]
    @tweet_list = Tweet.where(username: username)
    if @tweet_list.nil?
      @tweet_list = ["this is a tweet"]
    end
    binding.pry
    erb :timeline
  end
end





