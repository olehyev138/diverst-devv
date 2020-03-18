class AddPollsCountToEnterprises < ActiveRecord::Migration[5.2]
  def change
    add_column :enterprises, :polls_count, :integer

    Enterprise.find_each do |enterprise|
      Enterprise.reset_counters(enterprise.id, :polls)
    end
  end
end
