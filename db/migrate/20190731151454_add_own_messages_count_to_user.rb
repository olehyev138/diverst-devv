class AddOwnMessagesCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :own_messages_count, :integer
  end
end
