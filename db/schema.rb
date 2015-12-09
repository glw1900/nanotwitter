# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151117001744) do

  create_table "c_mentions", force: :cascade do |t|
    t.integer  "tweet_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "c_mentions", ["tweet_id"], name: "index_c_mentions_on_tweet_id"

  create_table "comments", force: :cascade do |t|
    t.integer  "tweet_id"
    t.integer  "commenter_id"
    t.string   "content"
    t.date     "c_time"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "comments", ["tweet_id"], name: "index_comments_on_tweet_id"

  create_table "favorites", force: :cascade do |t|
    t.integer  "tweet_id"
    t.integer  "user_id"
    t.date     "fa_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id"

  create_table "follows", force: :cascade do |t|
    t.integer  "followee_id"
    t.integer  "follower_id"
    t.date     "fo_time"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "follows", ["followee_id"], name: "index_follows_on_followee_id"

  create_table "hash_tags", force: :cascade do |t|
    t.string "name"
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "content"
    t.date     "pub_time"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "messages", ["receiver_id"], name: "index_messages_on_receiver_id"
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id"

  create_table "t_mentions", force: :cascade do |t|
    t.integer  "tweet_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "t_mentions", ["tweet_id"], name: "index_t_mentions_on_tweet_id"

  create_table "tags", force: :cascade do |t|
    t.integer "hash_id"
    t.integer "tweet_id"
  end

  create_table "tweets", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "content"
    t.integer  "retweet_id"
    t.date     "pub_time"
    t.string   "media_url"
    t.string   "has_comment"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "tweets", ["user_id"], name: "index_tweets_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "username"
    t.string   "password"
    t.string   "profile"
    t.date     "regist_date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "users", ["id"], name: "index_users_on_id"
  add_index "users", ["username"], name: "index_users_on_username"

end
