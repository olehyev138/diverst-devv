class IncrementResourceUrlLength < ActiveRecord::Migration
  def up
    change_column :resources, :url, :string, :limit => 255
  end
  
  def down
    change_column :resources, :url, :string, :limit => 191
  end
end
