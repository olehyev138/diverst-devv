class DeleteNewsFeedsNewsFeedLinks < ActiveRecord::Migration
  def change
    drop_table :news_feeds_news_feed_links
  end
end
