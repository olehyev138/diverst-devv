require 'rails_helper'

RSpec.describe MentorMailer, type: :mailer do

  describe '#session_scheduled' do
    let(:mentor) { create :user }
    let(:mentoring_session) { create :mentoring_session }
    let!(:mentorship_session) { mentoring_session.mentorship_sessions.create(user: mentor, mentoring_session: mentoring_session, role: "presenter", status: "pending") }
    let!(:mail) { described_class.session_scheduled(mentoring_session.id, mentor.id).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq "Mentoring Session Scheduled for #{mentoring_session.start.in_time_zone(mentor.time_zone).strftime("%m/%d/%Y %I:%M %p")}"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([mentor.email])
    end
  end

  describe '#session_updated' do
    let(:mentor) { create :user }
    let(:mentoring_session) { create :mentoring_session }
    let!(:mail) { described_class.session_updated(mentor.id, mentoring_session.id).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq "Mentoring Session Scheduled for #{mentoring_session.start.in_time_zone(mentor.time_zone).strftime("%m/%d/%Y %I:%M %p")} has been updated"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([mentor.email])
    end
  end

  describe '#session_canceled' do
    let(:mentor) { create :user }
    let(:mentoring_session) { create :mentoring_session }
    let!(:mail) { described_class.session_canceled(mentoring_session.start.in_time_zone(mentor.time_zone).strftime("%m/%d/%Y %I:%M %p"), mentor.id).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq "Mentoring Session Scheduled for #{mentoring_session.start.in_time_zone(mentor.time_zone).strftime("%m/%d/%Y %I:%M %p")} has been canceled"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([mentor.email])
    end
  end

  describe '#notify_declined_request' do
    let(:mentoring_request) { create :mentoring_request }
    let!(:mail) { described_class.notify_declined_request(mentoring_request.receiver.id, mentoring_request.sender.id).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq "Mentor Request Declined"
    end

    it 'renders the sender email' do
      expect(mail.to).to eq([mentoring_request.sender.email])
    end
  end

  describe '#notify_accepted_request' do
    let(:mentoring_request) { create :mentoring_request }
    let!(:mail) { described_class.notify_accepted_request(mentoring_request.receiver.id, mentoring_request.sender.id).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq "Mentor Request Accepted"
    end

    it 'renders the sender email' do
      expect(mail.to).to eq([mentoring_request.sender.email])
    end
  end

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
      expect(mail.subject).to eq "Reminder: Mentoring Session Scheduled for #{mentoring_session.start.in_time_zone(mentor.time_zone).strftime("%m/%d/%Y %I:%M %p")}"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([mentor.email])
    end
  end
end
