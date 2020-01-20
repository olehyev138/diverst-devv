module TimeZoneHelpers
  def self.timezones
    ActiveSupport::TimeZone.all.map { |tz| [tz.tzinfo.name, "(GMT#{tz.formatted_offset(true, '')}) #{tz.name}"] }
  end

  def self.time_zone(object, time_zone_field = 'time_zone')
    tz = ActiveSupport::TimeZone[ActiveSupport::TimeZone::MAPPING.key(object.send(time_zone_field))]
    "(GMT#{tz.formatted_offset(true, '')}) #{tz.name}"
  end
end
