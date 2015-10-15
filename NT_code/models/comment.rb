class Comment < ActiveRecord::Base
  has_many :c_mentions
  has_many :users, :through => :c_mentions
  belongs_to :tweet
end
