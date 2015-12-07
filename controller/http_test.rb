require 'http'
puts HTTP.post("http://hugetwitter.herokuapp.com/user/testuser/tweet").body
