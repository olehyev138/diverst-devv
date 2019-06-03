class AddArchiveAttributeToNewsAndResources < ActiveRecord::Migration
  def change
    add_column :news_feed_links, :archived_at, :datetime
    add_column :resources, :archived_at, :datetime
  end
end
