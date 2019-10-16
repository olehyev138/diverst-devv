class MentorshipAvailabilitySerializer < ApplicationRecordSerializer
  attributes :start, :end, :day, :user_time_zone, :local_start, :local_end

  def serialize_all_fields
    true
  end

  def start
    object.start
  end

  def end
    object.end
  end

  def user_time_zone
    object.user.time_zone
  end

  def local_start
    TimeHelper.timezone_conversion(object.start, user_time_zone, @instance_options[:time_zone])
  end

  def local_end
    TimeHelper.timezone_conversion(object.end, user_time_zone, @instance_options[:time_zone])
  end
end
