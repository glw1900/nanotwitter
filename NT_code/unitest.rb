ENV['RACK_ENV'] = 'development'

require 'rack/test'
require 'json'
require 'minitest/autorun'
require_relative 'app'
require 'faker'

include Rack::Test::Methods

def app
  Sinatra::Application
end

def write_Json(attributes)
  File.open("json_look_at_format.json","w") do |f|
    f.write( JSON.pretty_generate(attributes))
  end
end

describe "get home page" do 
  it "go to home page" do
    get '/'
    attributes = JSON.parse(last_response.to_json) # RACK
    attributes[:status].must_equal == 200
  end # end it
end

describe "get sign in page" do
  it "go to sign in page" do
    get '/signin'
    attributes = JSON.parse(last_response.to_json)
    attributes[:status].must_equal == 200
  end # end it
end

describe "create and delete a user" do
  it "create and delete a user" do
    fake_username = Faker::Internet.user_name
    post '/create/user',  {
      "username" => fake_username,
 	    "password" => "1234",
 	    "email" => "386783131@qq.com",
 	    "profile" => "info about this man"
 }
 user = User.find_by(username: fake_username)
 user.username.must_equal fake_username
   post '/delete/user/' + fake_username
   user = User.find_by(username: fake_username)
   user.must_be_nil
  end
end

def num_follow(follower_id, followee_id)
  return Follow.find_by_sql("SELECT * FROM follows WHERE follower_id = #{follower_id} AND followee_id = #{followee_id}").count
end


describe "create and delete a following" do
  it "create and delete a following" do
    follower_id = 0
    followee_id = 0
    loop do 
      follower_id = User.all.sample.id
      followee_id = User.all.sample.id
      break if (follower_id != followee_id and num_follow(follower_id, followee_id) == 0)
    end
    post '/create/follow', {
       "follower_id" => follower_id,
       "followee_id" => followee_id
      }
    num_follow(follower_id, followee_id).must_equal 1
    
    # begin deleting
    
    post '/delete/follow', {
       "follower_id" => follower_id,
       "followee_id" => followee_id
      }
      num_follow(follower_id, followee_id).must_equal 0
  end
end
 

#     describe "sign in as chen" do
#       it "sign in as chen" do
#       post '/signin',  {"username" => "user1", "password" => "1234"}
#       attributes = JSON.parse(last_response.to_json) # RACK
# #       attributes[:status].must_equal == 200
#       write_Json(attributes)
#       end
#     end # it
    
  #   it "create and delete new user" do
  #     post '/user/submit_regis', {"user" => {"username" => "chen", "password" => "123"}}.to_json
  #     attributes = JSON.parse(last_response.to_json) # RACK
  #     write_Json(attributes)
  #   end # it
  # end # describe
  
  