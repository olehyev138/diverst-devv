class AddRegionRefToGroups < ActiveRecord::Migration[5.2]
  def change
    add_reference :groups, :region, foreign_key: true
  end
end
