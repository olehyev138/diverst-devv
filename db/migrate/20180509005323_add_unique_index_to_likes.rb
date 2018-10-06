class AddUniqueIndexToLikes < ActiveRecord::Migration
  def change
    add_index :likes, [:user_id, :news_feed_link_id, :enterprise_id], unique: true
  end
end
