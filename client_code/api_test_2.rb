ENV['RACK_ENV'] = 'development'

require 'minitest/autorun'
require_relative 'lib'
require 'http'
require_relative 'apitestcode'

$url = "http://hugetwitter.herokuapp.com"



$tweet_id = 20
$user_id = 2
$recent_n_tweets = 100
$recent_user_id = 3
$recent_user_id = 12

# followship

$name_a = "ctz"
$name_b = "ctz2"


describe "a bunch of crazy stuff" do
  it "get tweet by id" do
    response = get_tweet_by_id($tweet_id)
    response.wont_be nil
  end
  #
  # it "get user info by id" do
  #   response = get_user_info($user_id)
  #   response.wont_be nil
  # end
  #
  # it "get recent tweets" do
  #   response = recent_50_tweets()
  #   response.wont_be nil
  # end
  #
  # it "get recent user n tweets" do
  #   response = recent_n_user_tweets($recent_user_id)
  #   response.wont_be nil
  # end
  #
  # it "build a friendship" do
  #   response = make_follow($name_a, $name_b)
  #   response.wont_be nil
  #
  #   response = destroy_follow($name_a, $name_b)
  #   response.wont_be nil
  # end
  #
  # it "test user timeline" do
  #   response = get_user_timeline($user_name)
  #   return response
  # end


end
