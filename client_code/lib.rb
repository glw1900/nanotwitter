require 'http'

class FantasticFour
  attr_accessor :url, :logged_username
  def set_url(url)
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


  def get_twitter_of_user(look_at_username)
    HTTP.get(@url + '/api/users/' + look_at_username,
    :params => {
      "username" => look_at_username })
    end


  def post_tweet(content, media_url, retweet_id)
    rt = HTTP.post(
    @url + '/create/tweet', :params => {
          "content" => content,
          "media_url" => media_url,
          "retweet_id" => retweet_id,
          "username" => @logged_username }).body
    return rt
  end

  def user_follow(followee_name)
    HTTP.post(
    @url + '/create/follow', :params => {
   "follower_name" => @logged_username,
   "followee_name" => followee_name
  })
  end

  def user_unfollow(followee_name)
    HTTP.post(
    @url + '/delete/follow', :params => {
   "follower_name" => @logged_username,
   "followee_name" => followee_name })
  end
end

ff = FantasticFour.new
puts ff.set_url("http://0.0.0.0:4567")
name = "ctz2"
puts ff.user_login(name, "abcd")
puts ff.post_tweet("this is from API", "media_url", "32")

username = "ctz2"
password = "abcd"
email = "123@qq.com"
profileInfo = "nothing"

look_at_username = "ctz"
puts ff.get_twitter_of_user(look_at_username)
# ff.create_user(username, password, email, profileInfo)
