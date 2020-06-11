class AddBooleanFlagToToggleVirtualEvents < ActiveRecord::Migration[5.2]
  def change
    unless column_exists? :enterprises, :virtual_events_enabled
      add_column :enterprises, :virtual_events_enabled, :boolean, default: false
    end
  end
end
