class RemoveShareLinkIdFromNewsFeedLinks < ActiveRecord::Migration
  def change
    remove_column :news_feed_links, :share_link_id, :integer
  end
end
