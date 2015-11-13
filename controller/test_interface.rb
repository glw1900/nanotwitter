require 'faker'
require 'bulk-insert-active-record'
# test_user_name = "testuser"

get '/test/tweets/:num' do
    testuser = User.find_by(username: "testuser")
    if(testuser != nil)
        testuser_id = testuser.id
        i = 0
        num = params['num'].to_i
        while(i < num) do
            Tweet.create(user_id: testuser_id, content: "a fake tweet")
            i = i + 1
        end
        'test fweets'
    else
    'testuser not exist'
    end
end


get '/test/reset' do
	testuser = User.find_by(username: "testuser")
	if testuser != nil
    	testuser_id = testuser.id
		Tweet.destroy_all("user_id = " + testuser_id.to_s)
		Follow.destroy_all("follower_id = " + testuser_id.to_s)
		Follow.destroy_all("followee_id = " + testuser_id.to_s)
	else
		User.create(username: "testuser", email: Faker::Internet.email, password: "1234", profile: nil) 
	end
    id =  User.find_by(username:"testuser").id
    # temp = "#{id}"
	"reset finished, testuser created #{id}"
end

get '/ttt' do
    'heiheihei'
end


get '/test/seed/:num' do
    # testuser_id = User.find_by(username: test_user_name)
	params[:num].to_i.times do |i|
    	User.create(username: "test_username#{i}", email: "fake@email.com",
    	password: "1234", profile: nil)
	end
	params[:num] +' users created'
end


get '/test/follow/:num' do
    testuser_id = User.find_by(username: "testuser").id
    make_follower(testuser_id, params[:num].to_i)
    "follow relationship set"
end

