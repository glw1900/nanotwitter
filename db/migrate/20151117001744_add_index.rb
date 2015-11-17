class AddIndex < ActiveRecord::Migration
  def change
      add_index :users, :username
      add_index :users, :id
      add_index :follows, :followee_id
      add_index :tweets, :user_id
      add_index :t_mentions, :tweet_id
      add_index :messages, :sender_id
      add_index :messages, :receiver_id
      add_index :favorites, :user_id
      add_index :comments, :tweet_id
      add_index :c_mentions, :tweet_id
  end
end
