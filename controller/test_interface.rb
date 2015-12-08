require 'faker'
require 'bulk-insert-active-record'
get '/test/tweets/:num' do
  $redis.set("test_user_timeline_change") == "true"
  testuser = User.find_by(username: "testuser")
  if(testuser != nil)
      testuser_id = testuser.id
      i = 0
      num = params['num'].to_i
      while(i < num) do
        if Tweet.find_by(content: "a fake tweet #{i}").nil?
          Tweet.create(user_id: testuser_id, content: "a fake tweet #{i}")
        end
        i = i + 1
      end
  else
  'testuser not exist'
  end
  "succeed"
end

get '/test/reset/all' do
  User.delete_all()
  Tweet.delete_all()
  Follow.delete_all()
  Comment.delete_all()
  $redis.set("test_user_timeline_change") == "true"
  if User.find_by(username: "testuser").nil?
    User.create(username: "testuser", email: Faker::Internet.email, password: "1234", profile: nil)
  end
  id =  User.find_by(username:"testuser").id
  # temp = "#{id}"
  "reset finished, testuser created #{id}"
end

#
get '/test/seed/:num' do
  i = 0
  num = params[:num].to_i
  while i < num
    if User.find_by(username:"test_username#{i}").nil?
      User.create(username: "test_username#{i}", email: "fake@email.com", password: "1234", profile: nil)
    end
    i += 1
	end
	params[:num] +' users created'
end


get '/test/follow/:num' do
  testuser_id = User.find_by(username: "testuser").id
  make_follower(testuser_id, params[:num].to_i)
    "follow relationship set"
end

get '/test/status' do
  rt = Hash.new
  rt["number_users"] = User.all.count
  rt["number_tweets"] = Tweet.all.count
  rt["number_follow"] = Follow.all.count
  testuser = User.find_by(username: "testuser")
  if testuser != nil
    rt["testuser_exist"] = true
    rt["testuser_id"] = testuser.id
  else
    rt["testuser_exist"] = false
    rt["testuser_id"] = -1
  end
  rt.to_json
end
