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
require 'activerecord-import'
require 'bulk-insert-active-record'
# ActiveRecord::Import.require_adapter('sq')
# require 'controller/require_rb'
enable :sessions

set :public_folder, File.dirname(__FILE__)+'/bootstrap-3.3.5-dist'
require 'pry-byebug'
require 'json'
# require_relative 'process'

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

def delete_those(lst)
	str = "("
	for i in 0..(lst.count - 2)
		str = str + lst[i].to_s + ","
	end
	str = str + lst[lst.count - 1].to_s + ")"
	User.delete_all("id IN " + str)
end

def make_fake_tweets(num)
	testuser_id = User.find(username: "testuser")
	
	values = []
	columns = [:tweet_id, :content]
	
	1234.times do |time|
    	values.push [ testuser_id, Faker::Lorem.sentence]
    end
    Tweet.bulk_insert(values, columns )
end
# rt = user_a_look_at_user_b_homepage(1065, 1102)
# a = get_time_line(1374)
# pretty_print(a)
# A = User.find_by_sql("SELECT DISTINCT id FROM users")
# A = User.pluck(:id).sample(10)
# pretty_print(A)


# puts "=================================================="
# # puts User.find_by_sql("SELECT * FROM users WHERE id in #{str}").nil?
# puts Follow.all.count
# 
# 
# sample_ids = User.pluck(:id).sample(1234)
# 
# columns = [:follower_id, :followee_id]
#     
# values = []
# sample_ids.each do |follower_id|
#     values.push [follower_id, $testuser_id]
# end
# 
# Follow.bulk_insert(values, columns)
# 
# puts "=======================result==========================="
# puts Follow.all.count






puts "=================================================="
# puts User.find_by_sql("SELECT * FROM users WHERE id in #{str}").nil?
puts Tweet.all.count

make_fake_tweets(1234)



puts "=======================result==========================="
puts Tweet.all.count



















