class RemoveApprovedFromNewsFeedLinks < ActiveRecord::Migration
  def change
    remove_column :news_feed_links, :approved, :boolean
  end
end
