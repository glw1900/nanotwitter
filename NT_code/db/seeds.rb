# 50.times do |i|
#   User.create(username: "user ##{i}", email: "user##{i}@gmail.com",
#     password: "1234", profile: nil)  
# end

# 40.times do |i|
#   Follow.create(followee_id:i,follower_id:i+1,fo_time:"08/14/2015")
#   Follow.create(followee_id:i+1,follower_id:i,fo_time:"08/14/2015")
# end

for i in 0..50
  Tweet.create(user_id:i,content:"this is a tweet by user_id #{i}")
end