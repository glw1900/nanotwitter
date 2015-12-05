class User < ActiveRecord::Base
  has_many :tweets, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :users, :through => :messages
  has_many :follows, dependent: :destroy
  has_many :users, :through => :follows
  has_many :favorites, dependent: :destroy
  has_many :tweets, dependent: :destroy, :through => :favorites
  has_many :c_mentions
  has_many :comments, :through => :c_mentions
  has_many :t_mentions
  has_many :tweets, :through => :t_mentons
end
