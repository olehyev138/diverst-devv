class AddVirtualAttributeToInitiatives < ActiveRecord::Migration
  def change
    add_column :initiatives, :virtual, :boolean, default: false
  end
end
