class User < ActiveRecord::Base
  has_many :tweets
  has_many :messages
  has_many :users, :through => :messages
  has_many :follows
  has_many :users, :through => :follows
  has_many :favorites
  has_many :tweets, :through => :favorites
  has_many :c_mentions
  has_many :comments, :through => :c_mentions
  has_many :t_mentions
  has_many :tweets, :throuh => :t_mentons
end
