class ChangeNewsFeedLikesToLikes < ActiveRecord::Migration
  def change
    rename_table :news_feed_likes, :likes
  end
end
