class AddArchiveAttributeToNewsAndResources < ActiveRecord::Migration
  def change
  	add_column :news_links, :archived_at, :datetime
  	add_column :group_messages, :archived_at, :datetime
  	add_column :resources, :archived_at, :datetime
  end
end
