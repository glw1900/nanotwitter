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


