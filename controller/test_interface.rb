require 'faker'
require 'bulk-insert-active-record'
test_user_name = "testuser"

get '/test/tweets/:num' do
    $testuser_id = User.find_by(username: test_user_name)
    testuser_id = User.find_by(username: "testuser").id
	values_tweet = Array.new
	columns_tweet = [:user_id, :content]
    params['num'].to_i.times do |i|
        Tweet.create(user_id: testuser_id, content: Faker::Lorem.sentence)
    end
end


get '/test/reset' do
  $testuser_id = User.find_by(username: test_user_name)
	testuser = User.find_by(username: test_user_name)
	if testuser != nil
    $testuser_id = testuser.id
		Tweet.destroy_all("user_id = " + $testuser_id.to_s)
		Follow.destroy_all("follower_id = " + $testuser_id.to_s)
		Follow.destroy_all("followee_id = " + $testuser_id.to_s)
	else
		User.create(username: test_user_name, email: Faker::Internet.email, password: "1234", profile: nil) 
	end
end


get '/test/seed/:num' do
    $testuser_id = User.find_by(username: test_user_name)
	params['num'].to_i.times do |i|
    User.create(username: "test_username#{i}", email: Faker::Internet.email,
    password: "1234", profile: nil)
	end
end


get '/test/follow/:num' do
    testuser_id = User.find_by(username: test_user_name)
    make_follower(testuser_id, params['num'].to_i)
end

