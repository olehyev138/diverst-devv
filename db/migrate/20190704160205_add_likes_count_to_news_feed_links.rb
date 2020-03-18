class AddLikesCountToNewsFeedLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :news_feed_links, :likes_count, :integer

    NewsFeedLink.find_each do |news_feed_link|
      NewsFeedLink.reset_counters(news_feed_link.id, :likes)
    end
  end
end
