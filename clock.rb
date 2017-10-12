require 'clockwork'
require './config/boot'
require './config/environment'

include Clockwork

every(1.hour, 'Update cached segment members') { Segment.update_all_members }
every(1.day, 'Reset weekly rewards', at: '00:00') { ResetWeeklyRewardsJob.perform_later if Date.today.sunday? }
every(10.minutes, 'Sync Yammer users with Diverst users') { SyncYammerUsersJob.perform_later }
every(30.minutes, 'Sync Yammer members') { Group.all.each { |group| SyncYammerGroupJob.perform_later(group) } }
every(30.minutes, 'Save employee data samples') { SaveUserDataSamplesJob.perform_later }
every(1.day, 'Send daily notifications of groups to users', at: '00:00'){ UserGroupNotificationJob.perform_later('daily') }
every(1.day, 'Send daily notifications of pending users to group leaders', at: '00:00'){ Group.where(:pending_users => "enabled").find_each { |group| GroupLeaderNotificationsJob.perform_later(group) } }
every(7.days, 'Send weekly notifications of groups to users', at: '00:00'){ UserGroupNotificationJob.perform_later('weekly') }
every(3.hours, 'Send notifications of a poll when an initiative is finished'){ SendPollNotificationJob.perform_later }
