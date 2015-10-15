class CreateUser < ActiveRecord::Migration
  def up
  	create_table :users do |t|
  		t.string :email
      t.string :username
  		t.string :password
  		t.string :profile
  		t.datetime :regist_date
    end
  end

  def down
  		drop_table :users
  end
end
