ENV['RACK_ENV'] = 'development'

require 'rack/test'
require 'json'
require 'minitest/autorun'
require_relative 'main'
require 'faker'
require './controller/require_rb'

include Rack::Test::Methods
test_user_name = "testuser"
# helper functions
def app
  Sinatra::Application
end

def write_Json(attributes)
  File.open("json_look_at_format.json","w") do |f|
    f.write( JSON.pretty_generate(attributes))
  end
end

def num_follow(follower_id, followee_id)
  return Follow.find_by_sql("SELECT * FROM follows WHERE follower_id = #{follower_id} AND followee_id = #{followee_id}").count
end

def get_value_by_key_from_header(key)
  headers = JSON.parse(last_response.to_json)["header"]
  return headers[key]
end


describe "get home page" do 
  it "go to home page" do
    get '/'
    attributes = JSON.parse(last_response.to_json) # RACK
    attributes[:status].must_equal == 200
  end # end it
  
  it "go to sign in page" do
    get '/signin'
    attributes = JSON.parse(last_response.to_json)
    attributes[:status].must_equal == 200
  end # end it
end

describe "creation / deletion " do
  
  it "create and delete a user" do
    fake_username = Faker::Internet.user_name
    
    post '/create/user',  {
      "username" => fake_username,
 	    "password" => "1234",
      "re_password" => "1234",
 	    "email" => "386783131@qq.com",
 	    "profile" => "info about this man"
 }
 
    user = User.find_by(username: fake_username)
    user.username.must_equal fake_username

    get_value_by_key_from_header("successfully_sign_up").must_equal "true"
    
    post '/delete/user/' + fake_username
    user = User.find_by(username: fake_username)
    user.must_be_nil
    
    get_value_by_key_from_header("successfully_deleted").must_equal "true"
    
  end
  
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
    get_value_by_key_from_header("successfully_add_follow").must_equal "true"
    # begin deleting
    
    post '/delete/follow', {
       "follower_id" => follower_id,
       "followee_id" => followee_id
      }
      num_follow(follower_id, followee_id).must_equal 0
      get_value_by_key_from_header("successfully_deleted").must_equal "true"
  end
  
  it "create and delete a tweet" do
    poster_name = User.all.sample.username
    
    post '/create/tweet', {
      "content" => "this is a twitter",
      "media_url" => "http://somepic.jpg",
      "retweet_id" => "34",
      "username" => poster_name
    }
    
    headers = JSON.parse(last_response.to_json)["header"]
    # write_Json(attributes)
    posted_tweet_id = Integer(headers["posted_tweet_id"])
    get_value_by_key_from_header("successfully_posted").must_equal "true"
    
    # begin deleting tweet
    post '/delete/tweet', {
      "tweet_id" => "#{posted_tweet_id}",
    }
    get_value_by_key_from_header("successfully_deleted").must_equal "true"
    
  end
end

describe "test test_interface" do 
    it "test reset" do
      
      get '/test/reset', {}.to_json
      rt = User.find_by(username: test_user_name)
      rt.wont_be_nil
      if rt != nil
        test_user_id = rt.id
        Tweet.find_by_sql("SELECT * FROM tweets WHERE user_id = #{test_user_id}").count.must_equal 0
        Follow.find_by_sql("SELECT * FROM follows WHERE followee_id = #{test_user_id}").count.must_equal 0
    end
  end

  it "test making seed users" do
    prev_num_user = User.all.count
      get '/test/seed/1234', {}.to_json
      after_user_count = User.all.count
      (after_user_count - prev_num_user).must_equal 1234
  end
	
	it "test making fake user generating tweets" do
		rt = User.find_by(username: test_user_name)
  		rt.wont_be_nil
  		if rt != nil
  			test_user_id = rt.id
			prev_num_tweet = Tweet.find_by_sql("SELECT id FROM tweets WHERE user_id = #{test_user_id}").count
			get '/test/tweets/1234'
			after_num_tweet = Tweet.find_by_sql("SELECT id FROM tweets WHERE user_id = #{test_user_id}").count
		end
		(after_num_tweet - prev_num_tweet).must_equal 1234
	end
  
	it "test making other users follow the fake guys" do
		rt = User.find_by(username: test_user_name)
  		rt.wont_be_nil
  		if rt != nil
  			test_user_id = rt.id
        get '/test/follow/1234'
        follower_num = Follow.find_by_sql("SELECT follower_id FROM follows WHERE followee_id = #{test_user_id}").count
        follower_num.must_equal 1234
      end
	end
	
	
end
  
  