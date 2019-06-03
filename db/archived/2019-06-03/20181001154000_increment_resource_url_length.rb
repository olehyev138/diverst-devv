class IncrementResourceUrlLength < ActiveRecord::Migration[5.1]
  def up
    change_column :resources, :url, :string, :limit => 255
  end
  
  def down
    change_column :resources, :url, :string, :limit => 191
  end
end
