class AddRequiredToFields < ActiveRecord::Migration
  def change
    add_column :fields, :required, :boolean, default: false
  end
end
