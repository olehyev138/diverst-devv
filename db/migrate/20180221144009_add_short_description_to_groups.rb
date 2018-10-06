class AddShortDescriptionToGroups < ActiveRecord::Migration
  def change
  	add_column :groups, :short_description, :text
  end
end
