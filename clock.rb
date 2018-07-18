require 'clockwork'
require './config/boot'
require './config/environment'

include Clockwork

every(5.hours, 'Update cached segment members') { Segment.update_all_members }
every(1.hour, 'Send hourly notifications of groups to users'){ UserGroupNotificationJob.perform_later('hourly') }
every(1.day, 'Reset weekly rewards', at: '00:00') { ResetWeeklyRewardsJob.perform_later if Date.today.sunday? }

every(1.day, 'Send daily notifications of groups to users', at: '00:00'){ UserGroupNotificationJob.perform_later('daily') }
every(1.day, 'Send daily notifications of pending users to group leaders', at: '00:00'){ Group.where(:pending_users => "enabled").find_each { |group| GroupLeaderMemberNotificationsJob.perform_later(group) } }
every(1.day, 'Send daily notifications of pending comments to group leaders', at: '00:00'){ Group.find_each { |group| GroupLeaderCommentNotificationsJob.perform_later(group) } }
every(1.day, 'Send daily notifications of pending posts to group leaders', at: '00:00'){ Group.find_each { |group| GroupLeaderPostNotificationsJob.perform_later(group) } }
every(1.day, 'Send daily reminders for upcoming mentoring sessions', at: '00:00'){ MentoringSessionSchedulerJob.perform_later }
every(7.days, 'Send weekly notifications of groups to users', at: '00:00'){ UserGroupNotificationJob.perform_later('weekly') }
every(3.hours, 'Send notifications of a poll when an initiative is finished'){ SendPollNotificationJob.perform_later }