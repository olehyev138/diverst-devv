class AddGroupsCountToEnterprises < ActiveRecord::Migration
  def change
    add_column :enterprises, :groups_count, :integer

    Enterprise.find_each do |enterprise|
      Enterprise.reset_counters(enterprise.id, :groups)
    end
  end
end
