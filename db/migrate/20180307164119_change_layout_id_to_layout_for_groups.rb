class ChangeLayoutIdToLayoutForGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :layout_id, :integer
    add_column    :groups, :layout, :string
  end
end
