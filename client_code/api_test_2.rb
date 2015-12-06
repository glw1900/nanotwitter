ENV['RACK_ENV'] = 'development'

require 'minitest/autorun'
require_relative 'lib'
require 'http'

$url = "http://protected-refuge-6584.herokuapp.com"



$tweet_id = 100
$user_id
$recent_n_tweets = 100
$recent_n_user_tweets
$recent_user_id = 12

# followship

$name_a = "ctz"
$name_b = "ctz2"


describe "a bunch of crazy stuff" do
  it "get tweet by id" do
    response = get_tweet_by_id($tweet_id)
    response.wont_be nil
  end

  it "get user info by id" do
    response = get_user_info($user_id)
    response.wont_be nil
  end

  it "get recent tweets" do
    response = recent_50_tweets($recent_n_tweets)
    response.wont_be nil
  end

  it "get recent user n tweets" do
    response = recent_n_user_tweets($recent_user_id)
    response.wont_be nil
  end

  it "build a friendship" do
    response = make_follow($name_a, $name_b)
    response.wont_be nil

    response = destroy_follow($name_a, $name_b)
    response.wont_be nil
  end


end
