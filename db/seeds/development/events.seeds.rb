after 'development:enterprise' do
  spinner = TTY::Spinner.new(":spinner Populating enterprises with events...", format: :spin_2)
  spinner.run do |spinner|
    Enterprise.update_all(:time_zone => ActiveSupport::TimeZone.find_tzinfo("Eastern Time (US & Canada)").name)

    Enterprise.all.each do |enterprise|
      [:second, :minute, :hour, :day, :week, :month].each do |period|
        FrequencyPeriod.create(name: period)
      end

      enterprise.clockwork_database_events.create!(
        [
          {:name => "Send weekly notifications of groups to users", :frequency_period_id => FrequencyPeriod.find_by(:name => "day").id, :disabled => false, :at => "00:10", :day => "sunday", :tz => enterprise.time_zone, :job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "{\"notifications_frequency\":\"weekly\"}"},
          {:name => "Send weekly notifications of groups to users", :frequency_period_id => FrequencyPeriod.find_by(:name => "day").id, :disabled => false, :at => "00:10", :day => "monday", :tz => enterprise.time_zone, :job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "{\"notifications_frequency\":\"weekly\"}"},
          {:name => "Send weekly notifications of groups to users", :frequency_period_id => FrequencyPeriod.find_by(:name => "day").id, :disabled => false, :at => "00:10", :day => "tuesday", :tz => enterprise.time_zone, :job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "{\"notifications_frequency\":\"weekly\"}"},
          {:name => "Send weekly notifications of groups to users", :frequency_period_id => FrequencyPeriod.find_by(:name => "day").id, :disabled => false, :at => "00:10", :day => "wednesday", :tz => enterprise.time_zone, :job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "{\"notifications_frequency\":\"weekly\"}"},
          {:name => "Send weekly notifications of groups to users", :frequency_period_id => FrequencyPeriod.find_by(:name => "day").id, :disabled => false, :at => "00:10", :day => "thursday", :tz => enterprise.time_zone, :job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "{\"notifications_frequency\":\"weekly\"}"},
          {:name => "Send weekly notifications of groups to users", :frequency_period_id => FrequencyPeriod.find_by(:name => "day").id, :disabled => false, :at => "00:10", :day => "friday", :tz => enterprise.time_zone, :job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "{\"notifications_frequency\":\"weekly\"}"},
          {:name => "Send weekly notifications of groups to users", :frequency_period_id => FrequencyPeriod.find_by(:name => "day").id, :disabled => false, :at => "00:10", :day => "saturday", :tz => enterprise.time_zone, :job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "{\"notifications_frequency\":\"weekly\"}"},
          {:name => "Send daily notifications of groups to users", :frequency_period_id => FrequencyPeriod.find_by(:name => "day").id, :disabled => false, :at => "00:10", :day => nil, :tz => enterprise.time_zone, :job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "{\"notifications_frequency\":\"daily\"}"}
        ]
      )
    end
    spinner.success("[DONE]")
  end
end