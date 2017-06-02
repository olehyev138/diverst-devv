class RenameEnableNotificationToFrequencyNotification < ActiveRecord::Migration
  class MigrationUserGroup < ActiveRecord::Base
    self.table_name = :user_groups

    enum frequency_notification: [:real_time, :daily, :weekly, :disabled]
  end

  def up
    add_column :user_groups, :frequency_notification, :integer

    MigrationUserGroup
      .where(enable_notification: false)
      .update_all(frequency_notification: MigrationUserGroup.frequency_notifications[:disabled])

    MigrationUserGroup
      .where(enable_notification: true)
      .update_all(frequency_notification: MigrationUserGroup.frequency_notifications[:daily])

    remove_column :user_groups, :enable_notification
    change_column_null :user_groups, :frequency_notification, from: true, to: false
  end

  def down
    add_column :user_groups, :enable_notification, :boolean

    MigrationUserGroup
      .where(frequency_notification: MigrationUserGroup.frequency_notifications[:disabled])
      .update_all(enable_notification: false)

    MigrationUserGroup
      .where.not(frequency_notification: MigrationUserGroup.frequency_notifications[:disabled])
      .update_all(enable_notification: true)

    remove_column :user_groups, :frequency_notification
  end
end
