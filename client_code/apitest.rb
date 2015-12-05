require 'minitest/autorun'

describe "can create and delete user and login" do
  before do
    url = "http://protected-refuge-6584.herokuapp.com"
    set_host_url(url)
  end

  it "can create user and login" do
    username = "test1"
    password = "11"
    email = "test1@gmail.com"
    info = "Nothing"
    create_user(username,password,email,info).must_equal true
    user_login(username,password).must_equal true
  end

  after do
    user_delete_everything("test1")
  end
end

describe "follow and twitter" do
  before do
    url = "http://protected-refuge-6584.herokuapp.com"
    set_host_url(url)
    create_user("test1","11","test1@gmail.com","Nothing")
    create_user("test2","11","test2@gmail.com","Nothing")
    user_login("test1","11")
  end

  it "can follow and unfollow" do
    user_follow("test2").must_equal true
    user_unfollow("test2").must_equal true
  end

  it "can get and post twitter" do
    post_tweet("this is my twitter","",3).must_equal true
    get_twitter_of_user("test1")[0]["text"].must_equal "this is my twitter"
  end

  it "can get recent tweet" do
    get_newest_fifty_tweet().size.must_equal 50
  end

  after do
    user_delete_everything("test1")
    user_delete_everything("test2")
  end
end

describe "get timeline" do
  before do
    url = "http://protected-refuge-6584.herokuapp.com"
    set_host_url(url)
    create_user("test1","11","test1@gmail.com","Nothing")
    create_user("test2","11","test2@gmail.com","Nothing")
    user_login("test1","11")
  end

  it "can get timeline" do
    user_follow("test2")
    user_logout()
    user_login("test2","11")
    post_tweet("this is my another tweet","",3)
    user_logout()
    user_login("test1","11")
    user_get_timeline()[0]["text"].must_equal "this is my another tweet"
  end
  
  after do
    user_delete_everything("test1")
    user_delete_everything("test2")
  end

end



