require 'minitest/autorun'
require_relative 'lib'
require_relative 'liangwei'



describe "can create and delete user and login" do
  before do
    @test = FantasticFour.new
    url = "http://protected-refuge-6584.herokuapp.com"
    @test.set_host_url(url)
  end

  it "can create user and login" do
    username = "test1"
    password = "11"
    email = "test1@gmail.com"
    info = "Nothing"
    @test.create_user(username,password,email,info).must_equal true
    @test.user_login(username,password).must_equal true
  end

  after do
    @test.user_delete_everything("test1")
  end
end

describe "follow and twitter" do
  before do
    @test = FantasticFour.new
    url = "http://protected-refuge-6584.herokuapp.com"
    @test.set_host_url(url)
    @test.create_user("test1","11","test1@gmail.com","Nothing")
    @test.create_user("test2","11","test2@gmail.com","Nothing")
    @test.user_login("test1","11")
  end

  it "can follow and unfollow" do
    @test.user_follow("test2").must_equal true
    @test.user_unfollow("test2").must_equal true
  end

  it "can get and post twitter" do
    @test.post_tweet("this is my twitter","",3).must_equal true
    @test.get_twitter_of_user("test1")[0]["text"].must_equal "this is my twitter"
  end

  it "can get recent tweet" do
    @test.get_newest_fifty_tweet().size.must_equal 50
  end

  after do
    @test.user_delete_everything("test1")
    @test.user_delete_everything("test2")
  end
end

describe "get timeline" do
  before do
    @test = FantasticFour.new
    url = "http://protected-refuge-6584.herokuapp.com"
    @test.set_host_url(url)
    @test.create_user("test1","11","test1@gmail.com","Nothing")
    @test.create_user("test2","11","test2@gmail.com","Nothing")
    @test.user_login("test1","11")
  end

  it "can get timeline" do
    @test.user_follow("test2")
    @test.user_logout()
    @test.user_login("test2","11")
    @test.post_tweet("this is my another tweet","",3)
    @test.user_logout()
    @test.user_login("test1","11")
    @test.user_get_timeline()[0]["text"].must_equal "this is my another tweet"
  end
  
  after do
    @test.user_delete_everything("test1")
    @test.user_delete_everything("test2")
  end

end



