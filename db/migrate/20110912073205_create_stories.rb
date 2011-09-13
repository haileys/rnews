class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :title
      t.string :url
      t.integer :points
      t.integer :user_id
      t.integer :category_id

      t.timestamps
    end
    
    add_index :stories, :title
    add_index :stories, :points
    add_index :stories, :user_id
    add_index :stories, :category_id
  end
end
