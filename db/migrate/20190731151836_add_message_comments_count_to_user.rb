class AddMessageCommentsCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :message_comments_count, :integer
  end
end
