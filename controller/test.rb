def user_a_look_at_user_b_homepage(user_a_id, user_b_id)
  # TODO: MISS FAVOURITES, FOLLOW NUMBER, FOLLOWER NUMBER
  sql = "SELECT T.content, T.created_at, T.retweet_id, U.username FROM tweets AS T, users AS U WHERE T.user_id = U.id AND T.user_id = #{user_b_id} "
  records_array = ActiveRecord::Base.connection.execute(sql)
  tw_array = tweet_array_to_hash(records_array, true)
  
  image_url = "https://upload.wikimedia.org/wikipedia/commons/f/f6/Barack_Obama_and_Bill_Clinton_profile.jpg"
  rt = {}
  rt["logged_user_profile"] = get_user_profile(user_a_id)
  rt["followee_id"] = user_b_id
  rt["homepage_tweet_list"] = tw_array
  rt["username"] = User.find_by(id: user_b_id).username
  rt["follow_number"] = how_many_do_i_follow(user_b_id)
  rt["follower_number"] = how_many_follow_me(user_b_id)

  cache = {}
  cache["follow_number"] = rt["follow_number"] 
  cache["follower_number"] = rt["follower_number"]
  cache["tweet_number"] = tw_array.length

  if(!$redis.exists(viewer_profile))
    $redis.hset(viewer_profile, cache.to_json)
  end


  mode = "user_viewing_self"
  if user_a_id != user_b_id
    follow_list = Follow.where(followee_id: user_b_id, follower_id: user_a_id)
    if follow_list.size() == 1
      mode = "user_viewing_followed"
    else
      mode = "user_viewing_unfollowed"
    end
  end
  rt["mode"] = mode
  return rt
end