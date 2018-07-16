class RemoveIsPinnedFromNewsFeedLinks < ActiveRecord::Migration
  def change
    remove_column :news_feed_links, :is_pinned, :boolean
  end
end
