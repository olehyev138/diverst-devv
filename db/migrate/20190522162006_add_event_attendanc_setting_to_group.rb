class AddEventAttendancSettingToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :event_attendance_visibility, :string
  end
end
