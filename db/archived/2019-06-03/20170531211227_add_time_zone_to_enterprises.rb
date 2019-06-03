class AddTimeZoneToEnterprises < ActiveRecord::Migration[5.1]
  def change
    add_column :enterprises, :time_zone, :string
  end
end
