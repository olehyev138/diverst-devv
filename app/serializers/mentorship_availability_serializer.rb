class MentorshipAvailabilitySerializer < ApplicationRecordSerializer
  attributes :start, :end, :day, :user_time_zone

  def serialize_all_fields
    true
  end

  def start
    if object.start.is_a? ActiveSupport::TimeWithZone
      TimeHelper.time_to_s(object.start)
    else
      object.start
    end
  end

  def end
    if object.end.is_a? ActiveSupport::TimeWithZone
      TimeHelper.time_to_s(object.end)
    else
      object.end
    end
  end

  def day
    if object.day.is_a? Integer
      TimeHelper.i_to_weekday(object.day)
    else
      object.day
    end
  end

  def user_time_zone
    object.user.time_zone
  end
end
