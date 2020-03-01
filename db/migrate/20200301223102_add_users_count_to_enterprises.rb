class AddUsersCountToEnterprises < ActiveRecord::Migration[5.2]
  def change
    add_column :enterprises, :users_count, :integer

    Enterprise.find_each do |enterprise|
      Enterprise.reset_counters(enterprise.id, :users)
    end
  end
end
