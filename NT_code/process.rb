def auth(user)
  email = user["email"]
  password = user["password"]
  u = User.find_by(email: email)
  # binding.pry
  if u.nil?
    return false
  end
  if u.password == password
    return true
  end
  return false
end


