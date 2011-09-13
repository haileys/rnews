class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :story_id
      t.integer :comment_id
      t.integer :points
      t.text :text

      t.timestamps
    end
    
    add_index :comments, :user_id
    add_index :comments, :story_id
    add_index :comments, :comment_id
    add_index :comments, :points
  end
end
