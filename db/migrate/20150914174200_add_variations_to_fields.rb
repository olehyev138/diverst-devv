class AddVariationsToFields < ActiveRecord::Migration
  def change
    change_table :fields do |t|
      t.boolean :alternative_layout, default: false # Is used to present a field differently. The exact use depends on the field type. See field classes to get more info.
    end
  end
end
