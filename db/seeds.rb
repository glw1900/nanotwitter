# User.destroy_all()
# Tweet.destroy_all()
# Follow.destroy_all()


# 50.times do |i|
#   User.create(username: "user#{i}", email: "user#{i}@gmail.com",
#     password: "1234", profile: nil)  
# end

# pool = []
# User.find_each do |user|
#   pool << user.id
# end 

# for id in pool
#   if id != pool[0] and id != pool[pool.size()]
#     Follow.create(followee_id:id,follower_id:id+1,fo_time:"08/14/2015")
#     Follow.create(followee_id:id+1,follower_id:id,fo_time:"08/14/2015")
#   end
# end

70.times do |i|
  Tweet.create(user_id:260,content:"This is my #{i} th tweet, do you like it?")
end

