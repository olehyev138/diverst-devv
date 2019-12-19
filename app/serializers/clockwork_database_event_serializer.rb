class ClockworkDatabaseEventSerializer < ApplicationRecordSerializer
  attributes :frequency, :frequency_period, :tz, :timezones

  def serialize_all_fields
    true
  end

  def timezones
    TimeZoneHelpers.timezones
  end

  def tz
    TimeZoneHelpers.time_zone(object, 'tz')
  end
end
