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
set :public_folder, File.dirname(__FILE__)+'/bootstrap-3.3.5-dist'
require 'pry-byebug'
require_relative 'users'
require_relative 'follow'

# get '/' do
#   @logged_in = false #0 when no user log in
#   if session["username"] != nil
#     @logged_in = true
#     @username = session["username"]
#   end
#   @parameters = Hash.new
#   @parameters["unlogged_twitter_list"] = first_50_tweets_list
#   erb :home
# end

get '/' do
  @parameters = Hash.new
  @parameters["unlogged_twitter_list"] = first_50_tweets_lst
  erb :home
end

get '/timeline' do
  logged_username = session[:username]
  logged_id = User.find_by(username: logged_username).id
  @parameters = {}
  if !session["username"].nil?
    @parameters = get_time_line(logged_id)
    erb :timeline
  end
end

get '/signup' do
  erb :regist
end

get '/signin' do
  erb :sign_in
end

get '/logout' do
  erb :home
end


#go to the person page of some one
# get '/users/:username' do
#   if User.find_by(username: params[:username]).nil?
#     @mode = -1
#   else
#     @follow_from_id = User.find_by(username: session[:username]).id
#     @follow_to_id = User.find_by(username: params[:username]).id
#     @pageuser = params[:username]
#     if @follow_from_id == @follow_to_id
#       #user is checiing his or her own page
#       @mode = 0
#     elsif Follow.where(follower_id: @follow_from_id, followee_id: @follow_to_id).size > 0
#       #alreadt followed, show a button to unfollow
#       @mode = 1
#     else
#       #show a follow button
#       @mode = 2
#     end
#   end
#   @uname = params[:username]
#   user_id = User.find_by(username: @uname).id
#   @tweet_list = Tweet.where(user_id: user_id)
#   erb :personpage2
# end

get '/users/:username' do
  logged_username = session[:username]
  logged_id = User.find_by(username: username).id
  
  look_at_username = params[:username]
  look_at_user_id = User.find_by(username: look_at_username).id
  
  @parameters = user_a_look_at_user_b_homepage(logged_id, look_at_user_id)
  # TODO: erb here
end

get '/follow/:username' do
  @username = params[:username]
  #get the id of the current pageuser
  user_id = User.find_by(username: @username).id
  follow_ids = Follow.where(follower_id: user_id)
  # binding.pry
  @follow_users = []
  follow_ids.each do |follow|
    fname = User.find_by(id: follow.followee_id)
    @follow_users << fname
  end
  erb :followlist
end

post '/users/submit_regis' do
  u = check(params[:user])
  if u
    @user = User.new(u)
    if @user.save
      redirect '/signin'
    end
  end
  "Password not match"
end

post "/users/submit" do
  @tring_logging_in = params[:user]
  if auth(@tring_logging_in)
    username = @tring_logging_in["username"]
    session["username"] = username
    redirect '/timeline'
  else
    "Wrong Password"
  end
end

post "/users/submit_twitter" do
  tweet = {}
  tweet[:content] = params[:tweet]
  tweet[:media_url] = nil
  tweet[:retweet_id] = nil
  tweet[:user_id] = User.find_by(username: session["username"]).id
  tweet[:pub_time] = nil

  @new_tweet = Tweet.new(tweet)
  if @new_tweet.save
    redirect '/timeline'
  end
end

post '/followings/create' do
  @follow = Follow.new()
  @follow.follower_id = params[:follow_from_id]
  @follow.followee_id = params[:follow_to_id]
  # binding.pry
  if @follow.save
    username = User.find_by(id: params[:follow_from_id]).username
    redirect '/follow/' + username
  else
    "error when creating follow"
  end
end

post '/followings/destroy' do
  follow = Follow.find_by(followee_id: params[:follow_to_id], follower_id: params[:follow_from_id])
  follow_to_name = User.find_by(id: params[:follow_to_id]).username
  if follow != nil
    follow.destroy
    'unfollow success' + follow_to_name
  else
    "ooooooooooooops, you've never been a fan, are you?"
  end
  redirect '/users/' + follow_to_name
end

post '/delete/user/:username' do
  user = User.find_by(username: params[:username])
  if user != nil
    user.destroy
  end
end
