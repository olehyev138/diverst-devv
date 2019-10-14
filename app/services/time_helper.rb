class TimeHelper
  def self.time_to_s(time)
    time = time.to_i

    hours = (time % (3600 * 24)) / 3600
    noon = hours >= 12 ? 'PM' : 'AM'
    hours = hours % 12
    hours = 12 if hours == 0

    minutes = (time % 3600) / 60

    "#{hours}:#{'%02d' % minutes} #{noon}"
  end

  def self.s_to_time(string)
    hours, rest = string.split(':')
    minutes, noon = rest.split(' ')

    hours = hours.to_i
    minutes = minutes.to_i

    hours = 0 if hours == 12

    hours * 3600 + minutes * 60 + (noon == 'PM' ? 12 * 3600 : 0)
  end

  def self.weekday_to_i(weekday)
    case weekday
    when 'Sunday'
      0
    when 'Monday'
      1
    when 'Tuesday'
      2
    when 'Wednesday'
      3
    when 'Thursday'
      4
    when 'Friday'
      6
    when 'Saturday'
      7
    else
      0
    end
  end

  def self.i_to_weekday(int)
    case int
    when 0
      'Sunday'
    when 1
      'Monday'
    when 2
      'Tuesday'
    when 3
      'Wednesday'
    when 4
      'Thursday'
    when 5
      'Friday'
    when 6
      'Saturday'
    else
      'Sunday'
    end
  end
end
