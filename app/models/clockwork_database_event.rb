class ClockworkDatabaseEvent < ApplicationRecord
  include PublicActivity::Common
  include ClockworkDatabaseEvent::Actions
  include TimeZoneValidation
  time_zone_attribute :tz

  # associations
  belongs_to :frequency_period
  belongs_to :enterprise

  # validations
  validates_length_of :method_args, maximum: 191
  validates_length_of :method_name, maximum: 191
  validates_length_of :job_name, maximum: 191
  validates_length_of :at, maximum: 191
  validates_length_of :day, maximum: 191
  validates_length_of :name, maximum: 191
  validates_presence_of :name
  validates_presence_of :frequency_quantity
  validates_presence_of :frequency_period
  validates_presence_of :enterprise
  validates_presence_of :job_name
  validates_presence_of :method_name

  # we want to make sure the timezone is valid
  validates_inclusion_of :day, in: Date::DAYNAMES.map(&:downcase), if: Proc.new { |c| c.day.present? }

  validate :valid_job

  before_save :downcase_attributes

  def downcase_attributes
    self.day = self.day.downcase if day.present?
  end

  def valid_job
    if job_name.present? && method_name.present?
      begin
        unless job_name.constantize.respond_to? method_name.to_sym
          errors.add(:method_name, 'does not exist')
          return false
        end
      rescue => e
        errors.add(:job_name, e.message)
        return false
      end
    end
    true
  end

  def frequency
    frequency_quantity.send(frequency_period.name.pluralize)
  end

  # checks if the event should execute
  def if?
    return false if disabled?
    return false if day.present? && Time.now.in_time_zone(tz).strftime('%A').downcase != day
    return false if at.present? && Time.now.in_time_zone(tz).strftime('%H:%M') != at

    true
  end

  # runs the actual event
  def run
    return unless if?

    job_name.constantize.send method_name, formatted_arguments
  end

  def formatted_arguments
    return if method_args.nil?

    args = JSON.parse(method_args)
    args[:enterprise_id] = enterprise_id
    args.symbolize_keys
  end
end
