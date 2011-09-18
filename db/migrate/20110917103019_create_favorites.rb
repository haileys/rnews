class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :category_id
      t.timestamps
    end
    
    add_index :favorites, :user_id
    add_index :favorites, :category_id
    add_index :favorites, :created_at
  end
end
