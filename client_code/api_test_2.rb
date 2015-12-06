ENV['RACK_ENV'] = 'development'

require 'minitest/autorun'
require_relative 'lib'
require 'http'
require_relative 'apitestcode'

$url = "http://hugetwitter.herokuapp.com"



$tweet_id = 3
$user_name = "meiyue"
$recent_user_name = "meiyue"

# followship

$name_a = "test1"
$name_b = "meiyue"


describe "a bunch of crazy stuff" do
  it "get tweet by id" do
    response = get_tweet_by_id($tweet_id)
    response.wont_be_nil
  end

  it "get user info by username" do
    response = get_user_info($user_name)
    response.wont_be_nil
  end

  it "get recent tweets" do
    response = recent_50_tweets()
    response.wont_be_nil
  end

  it "get recent user n tweets" do
    response = recent_n_user_tweets($recent_user_name)
    response.wont_be_nil
  end

  it "build a friendship" do
    response = make_follow($name_a, $name_b)
    response.wont_be_nil

    response = destroy_follow($name_a, $name_b)
    response.wont_be_nil
  end

  it "test user timeline" do
    response = get_user_timeline($user_name)
    response.wont_be_nil
  end

end
