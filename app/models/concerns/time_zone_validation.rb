module TimeZoneValidation
  extend ActiveSupport::Concern

  module ClassMethods
    attr_accessor :time_zone_attr

    def time_zone_attribute(attribute)
      @time_zone_attr = attribute
    end
  end

  def valid_time_zone
    valid_timezones = ActiveSupport::TimeZone.all.map { |tz| tz.tzinfo.name }

    unless valid_timezones.include?(self.send(self.class.time_zone_attr || :time_zone))
      errors.add(:time_zone, "isn't a valid timezone")
    end
  end

  included do
    validate :valid_time_zone
  end
end
