class AddMessageCommentsCountToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :message_comments_count, :integer
  end
end
