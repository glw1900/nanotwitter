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
<<<<<<< HEAD


get '/test/song' do
	session["username"]
end
=======
>>>>>>> a9d29c2e517473411faa0120d1d746bb5e2727c8
