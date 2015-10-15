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


get '/' do
  erb :homepage
end

get '/signup' do
  erb :sign_up
end

"""post '/user/submit' do
  @user =
end
"""
