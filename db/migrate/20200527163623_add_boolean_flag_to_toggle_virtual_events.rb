class AddBooleanFlagToToggleVirtualEvents < ActiveRecord::Migration
  def change
    add_column :enterprises, :virtual_events_enabled, :boolean, default: false 
  end
end
