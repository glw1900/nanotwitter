require "pry-byebug"

def auth(user)
  username = user["username"]
  password = user["password"]
  u = User.find_by(username: username)
  # binding.pry
  if u.nil?
    return false
  end
  if u.password == password
    return true
  end
  return false
end

def check(user)
  password = user["password"]
  re_password = user["re_password"]
  user["regist_date"] = nil
  if password == re_password
    user.delete("re_password")
    return user
  else
    return nil
  end
end

# print check({:re_password=>"abc", :password=>"abc"})


