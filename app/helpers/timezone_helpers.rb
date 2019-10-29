module TimeZoneHelpers
  def timezones
    ActiveSupport::TimeZone.all.map { |tz| [tz.tzinfo.name, "(GMT#{tz.formatted_offset(true, '')}) #{tz.name}"] }
  end

  def time_zone
    tz = ActiveSupport::TimeZone[ActiveSupport::TimeZone::MAPPING.key(object.time_zone)]
    "(GMT#{tz.formatted_offset(true, '')}) #{tz.name}"
  end
end
