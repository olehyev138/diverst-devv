class AddShareLinkFields < ActiveRecord::Migration
  def change
    add_column :news_feed_links, :share_link_id, :integer
    add_column :news_feeds, :share_link_id, :integer
  end
end
