require 'faker'
require 'bulk-insert-active-record'
test_user_name = "testuser"

get '/test/tweets/:num' do
    $testuser_id = User.find_by(username: test_user_name)
  testuser_id = User.find_by(username: "testuser").id
	values_tweet = Array.new
	columns_tweet = [:user_id, :content]
    params[:num].times do |i|
    	values_tweet.push [testuser_id, Faker::Lorem.sentence]
    end
    
    Tweet.bulk_insert(values_tweet, columns_tweet)
end

get '/test/reset' do
    $testuser_id = User.find_by(username: test_user_name)
	testuser = User.find_by(username: test_user_name)
	if testuser != nil
    $testuser_id = testuser.id
	# if needed deletes all tweets that the “testuser” ever created
		Tweet.destroy_all("user_id = " + $testuser_id.to_s)
	# if needed deletes all follows of the “testuser”
	
		Follow.destroy_all("follower_id = " + $testuser_id.to_s)
		Follow.destroy_all("followee_id = " + $testuser_id.to_s)
    # binding.pry
	else
		User.create(username: test_user_name, email: Faker::Internet.email, password: "1234", profile: nil) 
	end
end


get '/test/seed/:num' do
    $testuser_id = User.find_by(username: test_user_name)
	params[:num].times do |i|
  		User.create(username: "test_username#{i}", email: Faker::Internet.email,
    	password: "1234", profile: nil) 
	end
end


get '/test/follow/:num' do
    $testuser_id = User.find_by(username: test_user_name)
    make_follower($testuser_id, params[:num])
end

