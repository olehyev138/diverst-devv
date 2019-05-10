require 'rails_helper'

RSpec.describe MentorMailer, type: :mailer do
  describe '#session_scheduled' do
    let(:mentor) { create :user }
    let(:mentoring_session) { create :mentoring_session }
    let!(:mentorship_session) { mentoring_session.mentorship_sessions.create(user: mentor, mentoring_session: mentoring_session, role: 'presenter', status: 'pending') }
    let!(:mail) { described_class.session_scheduled(mentoring_session.id, mentor.id).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq "Mentoring Session Scheduled for #{mentoring_session.start.in_time_zone(mentor.default_time_zone).strftime("%m/%d/%Y %I:%M %p")}"
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
      expect(mail.subject).to eq "Mentoring Session Scheduled for #{mentoring_session.start.in_time_zone(mentor.default_time_zone).strftime("%m/%d/%Y %I:%M %p")} has been updated"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([mentor.email])
    end
  end

  describe '#session_canceled' do
    let(:mentor) { create :user }
    let(:mentoring_session) { create :mentoring_session }
    let!(:mail) { described_class.session_canceled(mentoring_session.start.in_time_zone(mentor.default_time_zone).strftime('%m/%d/%Y %I:%M %p'), mentor.id).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq "Mentoring Session Scheduled for #{mentoring_session.start.in_time_zone(mentor.default_time_zone).strftime("%m/%d/%Y %I:%M %p")} has been canceled"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([mentor.email])
    end
  end

  describe '#session_declined' do
    let(:creator) { create :user }
    let(:mentee) { create :user, enterprise: creator.enterprise }
    let(:mentoring_session) { create :mentoring_session }
    let!(:mail) { described_class.session_declined(creator.id, mentoring_session.id, mentee.id).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq "#{mentee.name} has declined your Mentoring Session"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([creator.email])
    end
  end

  describe '#notify_declined_request' do
    let(:mentoring_request) { create :mentoring_request }
    let!(:mail) { described_class.notify_declined_request(mentoring_request.receiver.id, mentoring_request.sender.id).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq 'Mentor Request Declined'
    end

    it 'renders the sender email' do
      expect(mail.to).to eq([mentoring_request.sender.email])
    end
  end

  describe '#notify_accepted_request' do
    let(:mentoring_request) { create :mentoring_request }
    let!(:mail) { described_class.notify_accepted_request(mentoring_request.receiver.id, mentoring_request.sender.id).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq 'Mentor Request Accepted'
    end

    it 'renders the sender email' do
      expect(mail.to).to eq([mentoring_request.sender.email])
    end
  end

  describe '#new_mentoring_request' do
    let(:mentor) { create :user }
    let(:mentee) { create :user }
    let(:mentoring_request) { create :mentoring_request, sender: mentee, receiver: mentor }
    let!(:mail) { described_class.new_mentoring_request(mentoring_request).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq 'New Mentoring Request'
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
      expect(mail.subject).to eq "Reminder: Mentoring Session Scheduled for #{mentoring_session.start.in_time_zone(mentor.default_time_zone).strftime("%m/%d/%Y %I:%M %p")}"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([mentor.email])
    end
  end

  context 'when enterprise wants to redirect emails and redirect_email_contact is set' do
    describe '#session_scheduled' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
      let(:mentor) { create :user, enterprise: enterprise }
      let(:mentoring_session) { create :mentoring_session }
      let!(:mail) { described_class.session_scheduled(mentoring_session.id, mentor.id).deliver_now }

      it 'renders the redirect_email_contact' do
        expect(mail.to).to eq([enterprise.redirect_email_contact])
      end
    end

    describe '#session_updated' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
      let(:mentor) { create :user, enterprise: enterprise }
      let(:mentoring_session) { create :mentoring_session }
      let!(:mail) { described_class.session_updated(mentor.id, mentoring_session.id).deliver_now }

      it 'renders the redirect_email_contact' do
        expect(mail.to).to eq([enterprise.redirect_email_contact])
      end
    end

    describe '#session_canceled' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
      let(:mentor) { create :user, enterprise: enterprise }
      let(:mentoring_session) { create :mentoring_session }
      let!(:mail) { described_class.session_canceled(mentoring_session.start.strftime('%m/%d/%Y %I:%M %p'), mentor.id).deliver_now }

      it 'renders the redirect_email_contact' do
        expect(mail.to).to eq([enterprise.redirect_email_contact])
      end
    end

    describe '#notify_declined_request' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
      let(:receiver) { create :user, enterprise: enterprise }
      let(:sender) { create :user, enterprise: enterprise }
      let(:mentoring_request) { create :mentoring_request, receiver: receiver, sender: sender }
      let!(:mail) { described_class.notify_declined_request(mentoring_request.receiver.id, mentoring_request.sender.id).deliver_now }

      it 'renders the redirect_email_contact' do
        expect(mail.to).to eq([enterprise.redirect_email_contact])
      end
    end

    describe '#notify_accepted_request' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
      let(:receiver) { create :user, enterprise: enterprise }
      let(:sender) { create :user, enterprise: enterprise }
      let(:mentoring_request) { create :mentoring_request, receiver: receiver, sender: sender }
      let!(:mail) { described_class.notify_accepted_request(mentoring_request.receiver.id, mentoring_request.sender.id).deliver_now }

      it 'renders the redirect_email_contact' do
        expect(mail.to).to eq([enterprise.redirect_email_contact])
      end
    end

    describe '#new_mentoring_request' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
      let(:mentor) { create :user, enterprise: enterprise }
      let(:mentee) { create :user, enterprise: enterprise }
      let(:mentoring_request) { create :mentoring_request, sender: mentee, receiver: mentor }
      let!(:mail) { described_class.new_mentoring_request(mentoring_request).deliver_now }

      it 'renders the redirect_email_contact' do
        expect(mail.to).to eq([enterprise.redirect_email_contact])
      end
    end

    describe '#session_reminder' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
      let(:mentor) { create :user, enterprise: enterprise }
      let(:mentoring_session) { create :mentoring_session }
      let!(:mail) { described_class.session_reminder(mentor.id, mentoring_session.id).deliver_now }

      it 'renders the redirect_email_contact' do
        expect(mail.to).to eq([enterprise.redirect_email_contact])
      end
    end
  end

  context 'when enterprise wants to redirect emails but redirect_email_contact is to blank' do
    describe '#session_scheduled' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let(:mentor) { create :user, enterprise: enterprise }
      let(:mentoring_session) { create :mentoring_session }
      let!(:mail) { described_class.session_scheduled(mentoring_session.id, mentor.id).deliver_now }

      it 'renders the fallback_email' do
        expect(mail.to).to eq([fallback_email])
      end
    end

    describe '#session_updated' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let(:mentor) { create :user, enterprise: enterprise }
      let(:mentoring_session) { create :mentoring_session }
      let!(:mail) { described_class.session_updated(mentor.id, mentoring_session.id).deliver_now }

      it 'renders the fallback_email' do
        expect(mail.to).to eq([fallback_email])
      end
    end

    describe '#session_canceled' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let(:mentor) { create :user, enterprise: enterprise }
      let(:mentoring_session) { create :mentoring_session }
      let!(:mail) { described_class.session_canceled(mentoring_session.start.strftime('%m/%d/%Y %I:%M %p'), mentor.id).deliver_now }

      it 'renders the fallback_email' do
        expect(mail.to).to eq([fallback_email])
      end
    end

    describe '#notify_declined_request' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let(:receiver) { create :user, enterprise: enterprise }
      let(:sender) { create :user, enterprise: enterprise }
      let(:mentoring_request) { create :mentoring_request, receiver: receiver, sender: sender }
      let!(:mail) { described_class.notify_declined_request(mentoring_request.receiver.id, mentoring_request.sender.id).deliver_now }

      it 'renders the fallback_email' do
        expect(mail.to).to eq([fallback_email])
      end
    end

    describe '#notify_accepted_request' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let(:receiver) { create :user, enterprise: enterprise }
      let(:sender) { create :user, enterprise: enterprise }
      let(:mentoring_request) { create :mentoring_request, receiver: receiver, sender: sender }
      let!(:mail) { described_class.notify_accepted_request(mentoring_request.receiver.id, mentoring_request.sender.id).deliver_now }

      it 'renders the fallback_email' do
        expect(mail.to).to eq([fallback_email])
      end
    end

    describe '#new_mentoring_request' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let(:mentor) { create :user, enterprise: enterprise }
      let(:mentee) { create :user, enterprise: enterprise }
      let(:mentoring_request) { create :mentoring_request, sender: mentee, receiver: mentor }
      let!(:mail) { described_class.new_mentoring_request(mentoring_request).deliver_now }

      it 'renders the fallback_email' do
        expect(mail.to).to eq([fallback_email])
      end
    end

    describe '#session_reminder' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let(:mentor) { create :user, enterprise: enterprise }
      let(:mentoring_session) { create :mentoring_session }
      let!(:mail) { described_class.session_reminder(mentor.id, mentoring_session.id).deliver_now }

      it 'renders the fallback_email' do
        expect(mail.to).to eq([fallback_email])
      end
    end
  end

  context 'when enterprise wants to stop all emails' do
    describe '#session_scheduled' do
      let(:enterprise) { create(:enterprise, disable_emails: true) }
      let(:mentor) { create :user, enterprise: enterprise }
      let(:mentoring_session) { create :mentoring_session }
      let!(:mail) { described_class.session_scheduled(mentoring_session.id, mentor.id).deliver_now }

      it 'renders null mail object' do
        expect(mail).to be(nil)
      end
    end

    describe '#session_updated' do
      let(:enterprise) { create(:enterprise, disable_emails: true) }
      let(:mentor) { create :user, enterprise: enterprise }
      let(:mentoring_session) { create :mentoring_session }
      let!(:mail) { described_class.session_updated(mentor.id, mentoring_session.id).deliver_now }

      it 'renders null mail object' do
        expect(mail).to be(nil)
      end
    end

    describe '#session_canceled' do
      let(:enterprise) { create(:enterprise, disable_emails: true) }
      let(:mentor) { create :user, enterprise: enterprise }
      let(:mentoring_session) { create :mentoring_session }
      let!(:mail) { described_class.session_canceled(mentoring_session.start.strftime('%m/%d/%Y %I:%M %p'), mentor.id).deliver_now }

      it 'renders null mail object' do
        expect(mail).to be(nil)
      end
    end

    describe '#notify_declined_request' do
      let(:enterprise) { create(:enterprise, disable_emails: true) }
      let(:receiver) { create :user, enterprise: enterprise }
      let(:sender) { create :user, enterprise: enterprise }
      let(:mentoring_request) { create :mentoring_request, receiver: receiver, sender: sender }
      let!(:mail) { described_class.notify_declined_request(mentoring_request.receiver.id, mentoring_request.sender.id).deliver_now }

      it 'renders null mail object' do
        expect(mail).to be(nil)
      end
    end

    describe '#notify_accepted_request' do
      let(:enterprise) { create(:enterprise, disable_emails: true) }
      let(:receiver) { create :user, enterprise: enterprise }
      let(:sender) { create :user, enterprise: enterprise }
      let(:mentoring_request) { create :mentoring_request, receiver: receiver, sender: sender }
      let!(:mail) { described_class.notify_accepted_request(mentoring_request.receiver.id, mentoring_request.sender.id).deliver_now }

      it 'renders the fallback_email' do
        expect(mail).to be(nil)
      end
    end

    describe '#new_mentoring_request' do
      let(:enterprise) { create(:enterprise, disable_emails: true) }
      let(:mentor) { create :user, enterprise: enterprise }
      let(:mentee) { create :user, enterprise: enterprise }
      let(:mentoring_request) { create :mentoring_request, sender: mentee, receiver: mentor }
      let!(:mail) { described_class.new_mentoring_request(mentoring_request).deliver_now }

      it 'renders null mail object' do
        expect(mail).to be(nil)
      end
    end

    describe '#session_reminder' do
      let(:enterprise) { create(:enterprise, disable_emails: true) }
      let(:mentor) { create :user, enterprise: enterprise }
      let(:mentoring_session) { create :mentoring_session }
      let!(:mail) { described_class.session_reminder(mentor.id, mentoring_session.id).deliver_now }

      it 'renders null mail object' do
        expect(mail).to be(nil)
      end
    end
  end
end
