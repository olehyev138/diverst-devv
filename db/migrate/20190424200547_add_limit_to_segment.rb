class AddLimitToSegment < ActiveRecord::Migration
  def change
    add_column :segments, :limit, :integer
  end
end
