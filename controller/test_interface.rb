require 'faker'
require 'bulk-insert-active-record'
# test_user_name = "testuser"

get '/test/tweets/:num' do
    testuser_id = User.find_by(username: "testuser").id
    params['num'].to_i.times do |i|
        Tweet.create(user_id: testuser_id, content: "lalal")
        # Tweet.create(user_id: testuser_id, content: Faker::Lorem.sentence)
    end
end


get '/test/reset' do
  # $testuser_id = User.find_by(username: test_user_name)
	testuser = User.find_by(username: "testuser")
	if testuser != nil
    # $testuser_id = testuser.id
    	testuser_id = testuser.id
		Tweet.destroy_all("user_id = " + testuser_id.to_s)
		Follow.destroy_all("follower_id = " + testuser_id.to_s)
		Follow.destroy_all("followee_id = " + testuser_id.to_s)
		# User.create(username: "testuser", email: Faker::Internet.email, password: "1234", profile: nil) 
	else
		User.create(username: "testuser", email: Faker::Internet.email, password: "1234", profile: nil) 
	end
	'reset finished, testuser created'
end


get '/test/seed/:num' do
    # testuser_id = User.find_by(username: test_user_name)
	params[:num].to_i.times do |i|
    	User.create(username: "test_username#{i}", email: Faker::Internet.email,
    	password: "1234", profile: nil)
	end
	params[:num] +' users created'
end


get '/test/follow/:num' do
    testuser_id = User.find_by(username: "testuser").id
    make_follower(testuser_id, params[:num].to_i)
    "follow relationship set"
end

