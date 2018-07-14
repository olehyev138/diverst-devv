class NewsFeedsNewsFeedLinks < ActiveRecord::Migration
  def change
    create_table :news_feeds_news_feed_links do |t|
      t.integer :news_feed_id
      t.integer :news_feed_link_id
    end
  end
end
