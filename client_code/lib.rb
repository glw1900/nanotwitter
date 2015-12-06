require 'http'
require 'json'

class FantasticFour
  attr_accessor :url, :logged_username, :status

  def initialize(url,username,password,email = nil,profileInfo = nil)
    self.set_host_url(url)
    @url = url
    @logged_username = username
    if email.nil?
      @status = self.user_login(username,password)
    else
      self.create_user(username,password,email,profileInfo)
      @status = self.user_login(username,password)
    end
  end

  def set_host_url(url)
    @url = url
    return @url
  end

  def user_login(username, password)
    @logged_username = username
    return JSON.parse(HTTP.post(@url + "/api/signin",
    :params => {
        :user => {
          "username" => username,
          "password" => password
      }
    }).body)["status"]
  end

  def create_user(username, password, email, profileInfo)
    HTTP.post(@url + '/create/user',
    :params => {
      "username" => username,
 	    "password" => password,
      "re_password" => password,
 	    "email" => email,
 	    "profile" => profileInfo
      })
  end

  def get_twitter_of_user(look_at_username)
    if @status
      rt = HTTP.get(@url + '/api/users/' + look_at_username,
      :params => {
        "logged_username" => @logged_username,
        "username" => look_at_username })
      return JSON.parse(rt.to_s.gsub(/\=\>/, ':'))["homepage_tweet_list"]
    else
      return false
    end
  end

  def post_tweet(content, media_url, retweet_id)
    if @status
      rt = HTTP.post(
      @url + '/create/tweet', :params => {
            "content" => content,
            "media_url" => media_url,
            "retweet_id" => retweet_id,
            "username" => @logged_username })
      return rt
    else
      return false
    end
  end


  def user_follow(followee_name)
    if @status
      return JSON.parse(HTTP.post(
      @url + '/api/create/follow', :params => {
     "follower_name" => @logged_username,
     "followee_name" => followee_name}).body)["status"]
    else
      return false
    end
  end


  def user_unfollow(followee_name)
    if @status
      return JSON.parse(HTTP.post(
      @url + '/api/delete/follow', :params => {
      "follower_name" => @logged_username,
      "followee_name" => followee_name }).body)["status"]
    else
      return false
    end
  end


  def user_logout()
    if @status
      HTTP.get(@url + '/logout').body
    else
      return false
    end
  end


  def user_delete_everything(username)
    if @status
      HTTP.post(@url+'/delete/user/'+username)
    else
      return false
    end
  end


  def user_get_timeline()
    if @status
      HTTP.get(@url)
    else
      return false
    end
  end

  def get_newest_fifty_tweet()
    return JSON.parse(HTTP.get(@url+'/api').body)
  end
end

