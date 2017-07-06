class AddFieldTypeToField < ActiveRecord::Migration
  def change
    change_table :fields do |t|
      t.string :field_type, default: 'regular' # Is used to present a field differently. The exact use depends on the field type. See field classes to get more info.
    end
  end
end
