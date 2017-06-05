class RenameEnableNotificationToFrequencyNotification < ActiveRecord::Migration
  class MigrationUserGroup < ActiveRecord::Base
    self.table_name = :user_groups

    enum notifications_frequency: [:real_time, :daily, :weekly, :disabled]
  end

  def up
    add_column :user_groups, :notifications_frequency, :integer, default: 0

    MigrationUserGroup
      .where(enable_notification: false)
      .update_all(notifications_frequency: MigrationUserGroup.notifications_frequencies[:disabled])

    MigrationUserGroup
      .where(enable_notification: true)
      .update_all(notifications_frequency: MigrationUserGroup.notifications_frequencies[:daily])

    remove_column :user_groups, :enable_notification
  end

  def down
    add_column :user_groups, :enable_notification, :boolean

    MigrationUserGroup
      .where(notifications_frequency: MigrationUserGroup.notifications_frequencies[:disabled])
      .update_all(enable_notification: false)

    MigrationUserGroup
      .where.not(notifications_frequency: MigrationUserGroup.notifications_frequencies[:disabled])
      .update_all(enable_notification: true)

    remove_column :user_groups, :notifications_frequency
  end
end
