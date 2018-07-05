require 'rails_helper'

RSpec.describe MentorMailer, type: :mailer do
  
  describe '#new_mentoring_request' do
    let(:mentor) { create :user }
    let(:mentee) { create :user }
    let(:mentoring_request) { create :mentoring_request, :sender => mentee, :receiver => mentor }
     let!(:mail) { described_class.new_mentoring_request(mentoring_request).deliver_now }
     
    it 'renders the subject' do
      expect(mail.subject).to eq "New Mentoring Request"
    end
    
    it 'renders the receiver email' do
      expect(mail.to).to eq([mentor.email])
    end
  end
  
  describe '#session_reminder' do
    let(:mentor) { create :user }
    let(:mentoring_session) { create :mentoring_session }
    let!(:mail) { described_class.session_reminder(mentor.id, mentoring_session.id).deliver_now }
     
    it 'renders the subject' do
      expect(mail.subject).to eq "Reminder: Mentoring Session Scheduled for #{mentoring_session.start.strftime("%m/%d/%Y %I:%M %p")}"
    end
    
    it 'renders the receiver email' do
      expect(mail.to).to eq([mentor.email])
    end
  end
end
