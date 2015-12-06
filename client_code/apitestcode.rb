
def get_tweet_by_id(tweet_id)
  response = JSON.parse(HTTP.get($url + "/api/v1/tweets/" + tweet_id.to_s).body)
  return response
end

def get_user_info(user_name)
  response = JSON.parse(HTTP.get($url + "/api/v1/users/" + user_name).body)
  puts response
  return response
end

def recent_50_tweets()
  response = JSON.parse(HTTP.get($url + "/api/v1/tweets/recent").body)
  return response
end

def recent_n_user_tweets(user_name)
  response = JSON.parse(HTTP.get($url + "/api/v1/users/" + user_name + "/tweets").body)
  return response
end

def make_follow(username_1, username_2)
  response = JSON.parse(HTTP.post($url + "/api/v1/create/follow", :params =>
  {
    "follower_name" => username_1,
    "followee_name" => username_2 }).body)
    #status
    if(response["status"] == "true")
      return true
    else
      return false
    end
end

def destroy_follow(username_1, username_2)
  response = JSON.parse(HTTP.post($url + "/api/v1/delete/follow", :params =>
  {
   "follower_name" => username_1,
   "followee_name" => username_2 }).body)
   if(response["status"] == "true")
     return true
   else
     return false
   end
end

def get_user_timeline(user_name)
  response = JSON.parse(HTTP.get($url + "/api/v1/timeline/" + user_name).body)
  return response
end
