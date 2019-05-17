class AddMoreTableIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :users_segments, :user_id
    add_index :poll_responses, :user_id
  end
end
