post '/create/comment' do
	comment = Comment.new()
	comment.tweet_id = params["tweet_id"]
	comment.content = params["content"]
	if session["username"] != nil
		comment.commenter_id = User.find_by(username: session["username"]).id
		if comment.save
			redirect 'tweets/' + params["tweet_id"]
		else
			"error when creating a comment"
		end
	else
		redirect '/signin'
	end
end

get '/test/createcomment' do
	erb :test
end
