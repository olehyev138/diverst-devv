class AddNecessaryIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :policy_groups, :user_id
  end
end
