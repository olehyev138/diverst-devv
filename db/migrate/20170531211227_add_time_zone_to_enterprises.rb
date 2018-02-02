class AddTimeZoneToEnterprises < ActiveRecord::Migration
  def change
    add_column :enterprises, :time_zone, :string
  end
end
