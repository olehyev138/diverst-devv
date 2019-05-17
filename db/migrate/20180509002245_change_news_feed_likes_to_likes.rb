class ChangeNewsFeedLikesToLikes < ActiveRecord::Migration[5.1]
  def change
    rename_table :news_feed_likes, :likes
  end
end
