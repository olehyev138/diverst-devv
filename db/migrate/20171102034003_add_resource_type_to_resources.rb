class AddResourceTypeToResources < ActiveRecord::Migration[5.1]
  def change
    add_column :resources, :resource_type, :string
    add_column :resources, :url, :string
  end
end
