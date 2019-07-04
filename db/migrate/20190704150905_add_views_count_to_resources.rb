class AddViewsCountToResources < ActiveRecord::Migration
  def change
    add_column :resources, :views_count, :integer

    Resource.find_each do |resource|
      Resource.reset_counters(resource.id, :views)
    end
  end
end
