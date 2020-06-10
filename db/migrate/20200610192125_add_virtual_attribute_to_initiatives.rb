class AddVirtualAttributeToInitiatives < ActiveRecord::Migration[5.2]
  def change
    add_column :initiatives, :virtual, :boolean, default: false
  end
end
