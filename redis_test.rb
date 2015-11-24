require 'redis'
require 'json'
require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './models/c_mention'        #Model class
require './models/comment'
require './models/favorite'
require './models/follow'
require './models/hash_tag'
require './models/message'
require './models/t_mention'
require './models/tag'
require './models/user'
require './models/tweet'
require './controller/require_rb'
require 'newrelic_rpm'


$redis = Redis.new(:url => "redis://redistogo:6089d2a4552e7700e65eebca0fdbca63@panga.redistogo.com:9792")

def first_50_tweets_lst
  /#
  return an array of hash
  #/
  newest_50_queue = "newest50queue"
  # if first_50_queue is empty
  if(!$redis.exists(newest_50_queue))
    sql = "SELECT T.content, T.created_at, T.retweet_id, U.username FROM tweets AS T, users AS U WHERE T.user_id = U.id ORDER BY T.created_at DESC LIMIT 50"
    records_array =  ActiveRecord::Base.connection.execute(sql)
    rt = tweet_array_to_hash(records_array, false)
    rt.each do |tweet|
    $redis.rpush(newest_50_queue, tweet.to_json)
    end
  end
  array_of_jsons = $redis.lrange( "newest50queue",0,-1)
  rt_array = Array.new
  array_of_jsons.each do |js|
      rt_array << JSON.parse(js)
  end
  return rt_array
end

