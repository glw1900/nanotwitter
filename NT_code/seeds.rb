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
require 'faker'
enable :sessions
set :public_folder, File.dirname(__FILE__)+'/bootstrap-3.3.5-dist'
require 'pry-byebug'

User.destroy_all()
Tweet.destroy_all()
Follow.destroy_all()

100.times do |i|
  User.create(username: "username#{i}", email: Faker::Internet.email,
    password: "1234", profile: nil)  
end

pool = []
User.find_each do |user|
  pool << user.id
end 


for i in 0...300
  follower = pool.sample
  followee = pool.sample
  if follower == followee
    next
  else
    Follow.create(followee_id: followee,follower_id: follower, fo_time: Faker::Date.backward(10000))
  end
end

for id in pool
  for i in 0...10
    Tweet.create(user_id:id, content: Faker::Lorem.sentence, created_at: Faker::Time.between(100.days.ago, Time.now, :all))
  end
end

