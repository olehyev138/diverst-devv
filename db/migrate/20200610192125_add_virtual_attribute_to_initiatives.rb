class AddVirtualAttributeToInitiatives < ActiveRecord::Migration[5.2]
  def change
    unless column_exists? :initiatives, :virtual
      add_column :initiatives, :virtual, :boolean, default: false
    end
  end
end
