class ClockworkDatabaseEvent < ActiveRecord::Base
    
    # associations
    belongs_to :frequency_period
    belongs_to :enterprise
    
    # validations
    validates_presence_of :name
    validates_presence_of :frequency_quantity
    validates_presence_of :frequency_period
    validates_presence_of :enterprise
    validates_presence_of :job_name
    validates_presence_of :method_name
    
    # we want to make sure the timezone is valid
    validates_inclusion_of :tz, :in => ActiveSupport::TimeZone.all.map(&:name)
    
    validate :valid_job
    
    before_save :downcase_attributes
    
    def downcase_attributes
        self.day = self.day.downcase if day.present?
    end
    
    def valid_job
        if job_name.present? && method_name.present?
            begin
                if not job_name.constantize.respond_to? method_name.to_sym
                    errors.add(:method_name, "does not exist")
                    return false 
                end
            rescue => e
                errors.add(:job_name, e.message)
                return false
            end
        end
        return true
    end
    
    def frequency
        frequency_quantity.send(frequency_period.name.pluralize)
    end
    
    # checks if the event should execute
    def if?
        return false if disabled?
        return false if day && Date.today.in_time_zone(tz).strftime("%A").downcase != day
        return false if at && Time.now.in_time_zone(tz).strftime('%H:%M') != at
        return true
    end
    
    # runs the actual event
    def run
        return unless if?
        job_name.constantize.send method_name, method_args
    end
end
