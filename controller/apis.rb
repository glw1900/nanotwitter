get '/api/users/:username' do
  #add follower_id and followee_id to @parameters
  logged_username = session[:username]
  logged_id = User.find_by(username: logged_username).id
  look_at_username = params[:username]
  look_at_user_id = User.find_by(username: look_at_username).id
  @parameters = user_a_look_at_user_b_homepage_with_redis(logged_id, look_at_user_id)
  return @parameters
end


get '/api/timeline/:username' do
  logged_username = params[:username]
  logged_id = User.find_by(username: logged_username).id
  @parameters = {}
  if !logged_username.nil?
    @parameters = get_time_line(logged_id)
  end
  @parameters.to_json
end