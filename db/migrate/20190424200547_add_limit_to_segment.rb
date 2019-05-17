class AddLimitToSegment < ActiveRecord::Migration[5.1]
  def change
    add_column :segments, :limit, :integer
  end
end
