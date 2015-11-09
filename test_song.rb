require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './models/c_mention'        #Model class
require './process'
enable :sessions
set :public_folder, File.dirname(__FILE__)+'/bootstrap-3.3.5-dist'
require 'pry-byebug'
require 'json'



def pretty_print(stuff)
	f = open("readable_json.json", "w")
	f.write(JSON.pretty_generate(JSON.parse(stuff.to_json)))
	f.close
end

pretty_print(get_following(1307))

