require 'rails_helper'

RSpec.describe GoogleCalendar, type: :service do
  describe '#build_mentor_link' do
    it 'returns google calendar link for mentoring session' do
      mentoring_session = create(:mentoring_session)
      link = GoogleCalendar.build_mentor_link(mentoring_session)
      expect(link.include?('calendar.google.com')).to be(true)
    end
  end
end
