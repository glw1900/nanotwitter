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
require 'json'
require_relative 'process'

def get_followees(user_id)
	sql = "SELECT followee_id FROM follows WHERE follower_id = #{user_id}"
	records_array = ActiveRecord::Base.connection.execute(sql)
	return records_array
end


def pretty_print(stuff)
	f = open("readable_json.json", "w")
	f.write(JSON.pretty_generate(JSON.parse(stuff.to_json)))
	f.close
end

# rt = user_a_look_at_user_b_homepage(1065, 1102)

<<<<<<< HEAD
# # puts JSON.pretty_generate(JSON.parse(rt.to_json))
# pretty_print(rt)

# puts "how_many_do_i_follow(1102):  #{how_many_do_i_follow(1102)} ==== "

puts "------------------------"
puts get_followees(2)
=======
# puts JSON.pretty_generate(JSON.parse(rt.to_json))
# pretty_print(rt)

# puts "how_many_do_i_follow(1102):  #{how_many_do_i_follow(1102)} ==== "
>>>>>>> fa175970e0aca214cc9b320b9516b4d8808901d3
