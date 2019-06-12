class RemoveHourlyUserGroupNotifications < ActiveRecord::Migration
  def change
    ClockworkDatabaseEvent.where(:job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "{\"notifications_frequency\":\"hourly\"}").delete_all
  end
end
