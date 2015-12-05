require 'http'

class FantasticFour
  attr_accessor :url, :logged_username
  def set_host_url(url)
    @url = url
    return @url
  end

  def user_login(username, password)
    @logged_username = username
    HTTP.post( @url + "/signin",
    :params => {
        :user => {
          "username" => username,
          "password" => password
      }
 })
  end
  def create_user(username, password, email, profileInfo)
    HTTP.post(@url + '/create/user',
    :params => {
      "username" => username,
 	    "password" => password,
      "re_password" => password,
 	    "email" => email,
 	    "profile" => profileInfo
 } )
    return
  end


  def get_twitter_of_user(look_at_username)to_s
    rt = HTTP.get(@url + '/api/users/' + look_at_username,
    :params => {
      "logged_username" => @logged_username,
      "username" => look_at_username })
      return JSON.parse(rt.to_s.gsub(/\=\>/, ':'))["homepage_tweet_list"]
    end


  def post_tweet(content, media_url, retweet_id)
    rt = HTTP.post(
    @url + '/create/tweet', :params => {
          "content" => content,
          "media_url" => media_url,
          "retweet_id" => retweet_id,
          "username" => @logged_username })
    return rt
  end

  def user_follow(followee_name)
    HTTP.post(
    @url + '/api/create/follow', :params => {
   "follower_name" => @logged_username,
   "followee_name" => followee_name
  })
  end

  def user_unfollow(followee_name)
    HTTP.post(
    @url + '/api/delete/follow', :params => {
   "follower_name" => @logged_username,
   "followee_name" => followee_name })
  end

  def user_logout()
    HTTP.get(@url + '/logout').body
  end

  def user_delete_everything(username)
    HTTP.post(@url+'/delete/user/'+username)
  end
end


ff = FantasticFour.new
puts ff.set_host_url("http://0.0.0.0:4567")
name = "ctz2"
puts ff.user_login(name, "abcd")
puts ff.post_tweet("this is from api2", "media_url", "32")

username = "ctz2"
password = "abcd"
email = "123@qq.com"
profileInfo = "nothing"

look_at_username = "ctz"
puts ff.get_twitter_of_user(look_at_username)
puts ff.user_follow(look_at_username)
puts ff.user_unfollow(look_at_username)
