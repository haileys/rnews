class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :story_id
      t.integer :comment_id
      t.integer :user_id
      t.integer :vote

      t.timestamps
    end
  end
end
