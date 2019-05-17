class CreateGroupMessagesSegments < ActiveRecord::Migration[5.1]
  def change
    create_table :group_messages_segments do |t|
      t.belongs_to :group_message
      t.belongs_to :segment
    end
  end
end
