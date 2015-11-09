class T_mention < ActiveRecord::Base
  belongs_to :user
  belongs_to :tweet
end
