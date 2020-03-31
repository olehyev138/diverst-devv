class AddViewsCountToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :views_count, :integer

    Group.find_each do |group|
      Group.reset_counters(group.id, :views)
    end
  end
end
