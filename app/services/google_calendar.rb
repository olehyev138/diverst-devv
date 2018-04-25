class GoogleCalendar
	attr_reader :build_link

	def self.build_link(event)
		"https://calendar.google.com/calendar/r/eventedit?#{{ dates: CGI.unescape("#{event.start.utc.strftime('%Y%m%dT%H%M%SZ')}/#{event.end.utc.strftime('%Y%m%dT%H%M%SZ')}"),
		 text:"#{event.name}", details:"#{event.description}", location:"#{event.location}"}.to_query}"
	end
end