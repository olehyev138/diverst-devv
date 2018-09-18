require 'clockwork'
require 'clockwork/database_events'
require './config/boot'
require './config/environment'

include Clockwork

module Clockwork
    
    configure do |config|
        #config[:logger] = Logger.new("#{Rails.root}/log/clockwork.log")
    end
    
    error_handler do |error|
        #Airbrake.notify_or_ignore(error)
    end
    
    # required to enable database syncing support
    Clockwork.manager = DatabaseEvents::Manager.new
    
    # reload the events from the database every day
    sync_database_events model: ClockworkDatabaseEvent, every: 30.second do |model_instance|
        model_instance.run
    end
    
    #every(10.minutes, 'Sync Yammer users with Diverst users') { SyncYammerUsersJob.perform_later }
    
    #every(30.minutes, 'Sync Yammer members') { Group.all.each { |group| SyncYammerGroupJob.perform_later(group) } }
    
    every(1.hour, 'Update cached segment members') { Segment.update_all_members }
    
    every(3.hours, 'Send notifications of a poll when an initiative is finished'){ SendPollNotificationJob.perform_later }
    
    every(1.day, 'Send daily reminders for upcoming mentoring sessions', at: '00:00'){ MentoringSessionSchedulerJob.perform_later }
    every(1.day, 'Reset weekly rewards', at: '00:00') { ResetWeeklyRewardsJob.perform_later if Date.today.sunday? }
    every(1.day, 'Send daily notifications of pending users to group leaders', at: '00:00'){ Group.where(:pending_users => "enabled").find_each { |group| GroupLeaderMemberNotificationsJob.perform_later(group) } }
    every(1.day, 'Send daily notifications of pending comments to group leaders', at: '00:00'){ Group.find_each { |group| GroupLeaderCommentNotificationsJob.perform_later(group) } }
    every(1.day, 'Send daily notifications of pending posts to group leaders', at: '00:00'){ Group.find_each { |group| GroupLeaderPostNotificationsJob.perform_later(group) } }
    every(1.day, 'Send daily reminders for upcoming mentoring sessions', at: '00:00'){ MentoringSessionSchedulerJob.perform_later }
    
end
