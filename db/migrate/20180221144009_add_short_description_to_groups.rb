class AddShortDescriptionToGroups < ActiveRecord::Migration[5.1]
  def change
  	add_column :groups, :short_description, :text
  end
end
