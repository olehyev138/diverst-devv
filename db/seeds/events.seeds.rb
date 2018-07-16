after :enterprise do
    Enterprise.update_all(:time_zone => "Eastern Time (US & Canada)")
    
    enterprise = Enterprise.last
    
    [:second, :minute, :hour, :day, :week, :month].each do |period|
        FrequencyPeriod.create(name: period)
    end
    
    enterprise.clockwork_database_events.create!(
        [
            {:name => "Send weekly notifications of groups to users", :frequency_period_id => FrequencyPeriod.find_by(:name => "day").id, :disabled => false, :at => "00:00", :tz => enterprise.time_zone, :job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "weekly"}
        ]
    )
end