require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './models/person'        #Model class
require './models/event'
require './models/regist'

get '/' do 
  erb :homepage
end

get '/signup' do
  erb :sign_up
end

post '/user/submit' do
end