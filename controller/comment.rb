post '/create/comment' do
	comment = Comment.new()
	comment.tweet_id = params["tweet_id"]
	comment.content = params["content"]
	comment.commenter_id = User.find_by(username: session["username"]).id
	if comment.save
		redirect 'tweet/' + params["tweet_id"]
	else
		"error when creating a comment"
	end
end

get '/test/createcomment' do
	erb :test
end


get '/test/song' do
	session["username"]
end