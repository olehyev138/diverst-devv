class AddEventAttendancSettingToGroup < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :event_attendance_visibility, :string
  end
end
