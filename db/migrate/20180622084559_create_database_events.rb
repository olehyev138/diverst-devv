class CreateDatabaseEvents < ActiveRecord::Migration
  def change
    create_table :frequency_periods do |t|
      t.string :name,   :null => false, :default => "daily"
      t.timestamps
    end
    
    create_table :clockwork_database_events do |t|
      t.string        :name,                :null => false
      t.integer       :frequency_quantity,  :null => false, :default => 1
      t.references    :frequency_period,    :null => false
      t.references    :enterprise,          :null => false
      t.boolean       :disabled,            :default => false
      t.string        :day,                 :null => true
      t.string        :at,                  :null => true
      t.string        :job_name,            :null => false
      t.string        :method_name,         :null => false
      t.string        :method_args,         :null => true
      t.string        :tz,                  :null => false
      t.timestamps
    end
    
    add_index :clockwork_database_events, :frequency_period_id
    
    [:second, :minute, :hour, :day, :week, :month].each do |period|
        FrequencyPeriod.create(name: period)
    end
    
    Enterprise.update_all(:time_zone => "Eastern Time (US & Canada)")
    
    Enterprise.find_each do |enterprise|
      enterprise.clockwork_database_events.create!(
          [
              {:name => "Send weekly notifications of groups to users", :frequency_period_id => FrequencyPeriod.find_by(:name => "day").id, :disabled => false, :at => "00:10", :day => "sunday", :tz => enterprise.time_zone, :job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "{\"notifications_frequency\":\"weekly\"}"},
              {:name => "Send weekly notifications of groups to users", :frequency_period_id => FrequencyPeriod.find_by(:name => "day").id, :disabled => false, :at => "00:10", :day => "monday", :tz => enterprise.time_zone, :job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "{\"notifications_frequency\":\"weekly\"}"},
              {:name => "Send weekly notifications of groups to users", :frequency_period_id => FrequencyPeriod.find_by(:name => "day").id, :disabled => false, :at => "00:10", :day => "tuesday", :tz => enterprise.time_zone, :job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "{\"notifications_frequency\":\"weekly\"}"},
              {:name => "Send weekly notifications of groups to users", :frequency_period_id => FrequencyPeriod.find_by(:name => "day").id, :disabled => false, :at => "00:10", :day => "wednesday", :tz => enterprise.time_zone, :job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "{\"notifications_frequency\":\"weekly\"}"},
              {:name => "Send weekly notifications of groups to users", :frequency_period_id => FrequencyPeriod.find_by(:name => "day").id, :disabled => false, :at => "00:10", :day => "thursday", :tz => enterprise.time_zone, :job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "{\"notifications_frequency\":\"weekly\"}"},
              {:name => "Send weekly notifications of groups to users", :frequency_period_id => FrequencyPeriod.find_by(:name => "day").id, :disabled => false, :at => "00:10", :day => "friday", :tz => enterprise.time_zone, :job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "{\"notifications_frequency\":\"weekly\"}"},
              {:name => "Send weekly notifications of groups to users", :frequency_period_id => FrequencyPeriod.find_by(:name => "day").id, :disabled => false, :at => "00:10", :day => "saturday", :tz => enterprise.time_zone, :job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "{\"notifications_frequency\":\"weekly\"}"},
              {:name => "Send daily notifications of groups to users", :frequency_period_id => FrequencyPeriod.find_by(:name => "day").id, :disabled => false, :at => "00:10", :day => nil, :tz => enterprise.time_zone, :job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "{\"notifications_frequency\":\"daily\"}"},
              {:name => "Send houry notifications of groups to users", :frequency_quantity => 1, :frequency_period_id => FrequencyPeriod.find_by(:name => "hour").id, :disabled => false, :at => "00:10", :day => nil, :tz => enterprise.time_zone, :job_name => "UserGroupNotificationJob", :method_name => "perform_later", :method_args => "{\"notifications_frequency\":\"hourly\"}"}
          ]
      )
    end
  end
end
