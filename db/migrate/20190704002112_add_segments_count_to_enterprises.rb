class AddSegmentsCountToEnterprises < ActiveRecord::Migration
  def change
    add_column :enterprises, :segments_count, :integer

    Enterprise.find_each do |enterprise|
      Enterprise.reset_counters(enterprise.id, :segments)
    end
  end
end
