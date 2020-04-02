class UpdateUserAndEnterpriseTimeZones < ActiveRecord::Migration[5.2]
  def up
    User.column_reload!
    User.find_each do |user|
      fix_time_zone(user)
    end

    Enterprise.column_reload!
    Enterprise.all.each do |enterprise|
      fix_time_zone(enterprise)
    end

    ClockworkDatabaseEvent.column_reload!
    ClockworkDatabaseEvent.all.each do |event|
      fix_time_zone(event, :tz)
    end
  end

  def down
  end

  private

  # Change the time_zone attribute from a Rails timezone string to an IANA timezone string
  # Defaults to UTC if the time_zone attribute isn't a valid Rails timezone string
  def fix_time_zone(object, timezone_attribute = :time_zone)
    begin
      object.send("#{timezone_attribute.to_s}=", ActiveSupport::TimeZone.find_tzinfo(object.send(timezone_attribute.to_s)).name)
      object.save(validate: false)
    rescue => err
      say "Couldn't convert '#{object.send(timezone_attribute.to_s)}' into a valid IANA timezone string, defaulting to UTC"
      object.send("#{timezone_attribute.to_s}=", ActiveSupport::TimeZone.find_tzinfo('UTC').name)
      object.save(validate: false)
    end
  end
end
