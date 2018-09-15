class AddFieldsForAdvancedReporting < ActiveRecord::Migration
  def change
    add_column :views, :group_id, :integer
    add_column :views, :folder_id, :integer
    add_column :views, :resource_id, :integer
    
    change_column_null :views, :news_feed_link_id, true
  end
end
