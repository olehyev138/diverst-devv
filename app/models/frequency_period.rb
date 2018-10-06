class FrequencyPeriod < ActiveRecord::Base
    validates_inclusion_of :name, :in => ["second", "minute", "hour", "day", "week", "month"]
end