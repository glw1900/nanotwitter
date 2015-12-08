post '/create/favor' do 
	tweet_id = params[:tweet_id]
	user_id = User.find_by(username: session[:username]).id
	favor = Favorite.find_by(tweet_id: tweet_id, user_id: user_id)
	if favor == nil
		favor = Favorite.new()
		favor.tweet_id = tweet_id
		favor.user_id = user_id
		if favor.save
		# refresh current page %%%%%%%%%%%%%%% how to %%%%%% avoid default behavior
			redirect '/favor/favorlist'
		end
	end
	redirect '/favor/favorlist'
end

post '/delete/favor' do 
	tweet_id = params[:tweet_id]
	user_id = User.find_by(username: session[:username]).id
	favor = Favorite.find_by(tweet_id: tweet_id, user_id: user_id)
	if favor != nil
		favor.destroy
		redirect 'favor/favorlist'
	end
end

get '/favor/favorlist' do
	user_id = User.find_by(username: session[:username]).id
	@parameters = {}
	@parameters["username"] = session[:username]
	@parameters["tweet_list"] = user_a_favor_tweet_list(user_id)
	#%%%%%%erb required 
	@parameters.to_json
end

get '/test/favor/create' do
	erb :test
end

get '/test/favor/delete' do
	erb :test_delete_favor
end