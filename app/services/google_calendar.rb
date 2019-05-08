class GoogleCalendar
  attr_reader :build_link

  def self.build_link(event)
    "https://calendar.google.com/calendar/r/eventedit?#{{ dates: CGI.unescape("#{event.start.utc.strftime('%Y%m%dT%H%M%SZ')}/#{event.end.utc.strftime('%Y%m%dT%H%M%SZ')}"),
		                                                        text: "#{event.name}", details: "#{event.description}", location: "#{event.location}" }.to_query}"
  end

  def self.build_mentor_link(mentor_session)
    description = ''

    if mentor_session.notes.present?
      description << "Notes:\n"
      description << "#{mentor_session.notes}\n\n"
    end

    description << 'Attendees:'
    mentor_session.users.each do |user|
      description << "\n#{user.first_name} #{user.last_name} - #{user.email}"
    end

    "https://calendar.google.com/calendar/r/eventedit?#{{ dates: CGI.unescape("#{mentor_session.start.utc.strftime('%Y%m%dT%H%M%SZ')}/#{mentor_session.end.utc.strftime('%Y%m%dT%H%M%SZ')}"),
		                                                        text: "Mentoring Session", details: "#{description}", location: "#{mentor_session.format}" }.to_query}"
  end
end
