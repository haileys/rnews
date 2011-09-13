class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.boolean :admin
      t.integer :points
      t.text :bio
      
      t.timestamps
    end
    
    add_index :users, :username, :unique => true
    add_index :users, :admin
  end
end
