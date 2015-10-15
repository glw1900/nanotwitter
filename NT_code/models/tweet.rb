class Tweet < ActiveRecord::Base
  has_many :comments
  has_many :t_mentions
  has_many :users through t_mentions
  has_many :favorites
  has_many :users through favorites
  has_many :tags
  has_many :hash_tags through tags
  belongs_to :user
end
