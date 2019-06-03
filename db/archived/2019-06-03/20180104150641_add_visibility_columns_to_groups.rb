class AddVisibilityColumnsToGroups < ActiveRecord::Migration[5.1]
  def change
  	add_column :groups, :latest_news_visibility, :string
  	add_column :groups, :upcoming_events_visibility, :string
  end
end
