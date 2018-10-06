class AddNecessaryIndexes < ActiveRecord::Migration
  def change
    add_index :policy_groups, :user_id
  end
end
