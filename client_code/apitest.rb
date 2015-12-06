require 'minitest/autorun'
require_relative 'lib'
require_relative 'liangwei'

describe "can create and delete user and login" do
  it "can create user and login" do
    # @test = FantasticFour.new("http://protected-refuge-6584.herokuapp.com","test1","11","test1@gmail.com","Nothing")
    @test = FantasticFour.new("0.0.0.0:4567","test1","11","test1@gmail.com","Nothing")
    @test.status.must_equal true
    @test.user_delete_everything("test1").must_equal true
  end
end
# describe "can create and delete user and login" do
#   it "can create user and login" do
#     @test = FantasticFour.new("http://protected-refuge-6584.herokuapp.com","test1","11","test1@gmail.com","Nothing")
#     @test.status.must_equal true
#     # @test.user_delete_everything("test1").must_equal true
#   end
# end

describe "follow and twitter" do
  before do
    @test = FantasticFour.new("http://protected-refuge-6584.herokuapp.com","test1","11","test1@gmail.com","Nothing")
    @test.create_user("test2","11","test2@gmail.com","Nothing")
  end

  it "can follow and unfollow" do
    @test.user_follow("test2").must_equal "true"
    puts @test.user_unfollow("test2").must_equal "true"
  end

  # it "can get and post twitter" do
  #   @test.post_tweet("this is my twitter","",3).must_equal true
  #   @test.get_twitter_of_user("test1")[0]["text"].must_equal "this is my twitter"
  # end

  it "can get recent tweet" do
    @test.get_newest_fifty_tweet().size.must_equal 50
  end

  after do
    @test.user_delete_everything("test1")
    @test.user_delete_everything("test2")
  end
end

# describe "get timeline" do
#   before do
#     @test = FantasticFour.new("http://protected-refuge-6584.herokuapp.com","test1","11","test1@gmail.com","Nothing")
#     @test.create_user("test2","11","test2@gmail.com","Nothing")
#   end

#   it "can get timeline" do
#     @test.user_follow("test2")
#     @test.user_login("test2","11")
#     @test.post_tweet("this is my another tweet","",3)
#     @test.user_login("test1","11")
#     @test.user_get_timeline()[0]["text"].must_equal "this is my another tweet"
#   end

#   after do
#     @test.user_delete_everything("test1")
#     @test.user_delete_everything("test2")
#   end

# end
