module TimeZoneHelpers
  def self.timezones
    ActiveSupport::TimeZone.all.map { |tz| [tz.tzinfo.name, "(GMT#{tz.formatted_offset(true, '')}) #{tz.name}"] }
  end

  def self.time_zone(object)
    tz = ActiveSupport::TimeZone[ActiveSupport::TimeZone::MAPPING.key(object.time_zone)]
    "(GMT#{tz.formatted_offset(true, '')}) #{tz.name}"
  end
end
