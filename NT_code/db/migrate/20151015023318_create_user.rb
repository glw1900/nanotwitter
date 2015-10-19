class CreateUser < ActiveRecord::Migration
  def up
  	create_table :users do |t|
  		t.string :email
      t.string :username
  		t.string :password
  		t.string :profile
  		t.date :regist_date
      t.timestamps null: false
    end
    create_table :tweets do |t|
      t.integer :user_id
  		t.string :content
  		t.integer :retweet_id
  		t.date :pub_time
      t.string :media_url
      t.timestamps null: false
    end
    create_table :follows do |t|
      t.integer :followee_id
  		t.integer :follower_id
      t.date :fo_time
      t.timestamps null: false
    end
    create_table :t_mentions do |t|
      t.integer :tweet_id
      t.integer :user_id
      t.timestamps null: false
    end
    create_table :comments do |t|
      t.integer :tweet_id
      t.integer :commenter_id
      t.string :content
      t.date :c_time
      t.timestamps null: false
    end
    create_table :c_mentions do |t|
      t.integer :tweet_id
      t.integer :user_id
      t.timestamps null: false
    end
    create_table :hash_tags do |t|
      t.string :name
    end
    create_table :tags do |t|
      t.integer :hash_id
      t.integer :tweet_id
    end
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.string :content
      t.date :pub_time
      t.timestamps null: false
    end
    create_table :favorites do |t|
      t.integer :tweet_id
      t.integer :user_id
      t.date :fa_time
      t.timestamps null: false
    end
  end

  def down
  		drop_table :users
      drop_table :tweets
      drop_table :follows
      drop_table :t_mentions
      drop_table :comments
      drop_table :c_mentions
      drop_table :hash_tags
      drop_table :tags
      drop_table :messages
      drop_table :favorites
  end
end
