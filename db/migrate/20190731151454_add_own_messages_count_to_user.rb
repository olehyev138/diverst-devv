class AddOwnMessagesCountToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :own_messages_count, :integer
  end
end
