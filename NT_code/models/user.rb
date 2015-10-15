class User < ActiveRecord::Base
  has_many :tweets
  has_many :messages
  has_many :users, :through => :messages
  has_many :follows
  has_many :users
end
