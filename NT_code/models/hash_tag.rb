class Hash_tag < ActiveRecord::Base
  has_many :tags
  has_many :tweets, through: :tags
end