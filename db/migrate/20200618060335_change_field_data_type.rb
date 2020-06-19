class ChangeFieldDataType < ActiveRecord::Migration[5.2]
  def change
    #
    # also done in make_field_data_polymorphic migration so it runs fully
    change_column :field_data, :data, :text
  end
end
