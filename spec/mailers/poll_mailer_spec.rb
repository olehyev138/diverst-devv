require 'rails_helper'

RSpec.describe PollMailer, type: :mailer do
  describe '#invitation' do
    let(:user) { create :user }
    let(:poll) { create :poll }
    let!(:group) { create :group }
    let!(:groups_poll) { create :groups_poll, poll: poll, group: group }
    let!(:custom_text) { create(:custom_text, erg: 'BRG', enterprise: user.enterprise) }
    let!(:email) { create(:email, enterprise: user.enterprise, mailer_name: 'poll_mailer', mailer_method: 'invitation', content: "<p>Hello %{user.name},</p>\r\n\r\n<p>You are invited to participate in the following online in Diverst: %{survey.title}</p>\r\n\r\n<p>%{click_here} to provide feedback and offer your thoughts and suggestions.</p>\r\n", subject: "You are Invited to participate in a '%{survey.title}' survey") }
    let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
    let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'survey.title')) }
    let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }
    let!(:mail) { described_class.invitation(poll, user).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq("You are Invited to participate in a '#{poll.title}' survey")
    end

    it 'includes message' do
      expect(mail.body.encoded).to include('You are invited to participate in the following online in Diverst')
    end

    it 'includes message in email body' do
      expect(mail.body.encoded).to include(user.name)
      expect(mail.body.encoded).to include('Click here')
    end
  end

  context 'when enterprise wants to redirect emails and redirect_email_contact is set' do
    describe '#invitation' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
      let(:user) { create :user, enterprise: enterprise }
      let(:poll) { create :poll }
      let!(:group) { create :group }
      let!(:groups_poll) { create :groups_poll, poll: poll, group: group }
      let!(:custom_text) { create(:custom_text, erg: 'BRG', enterprise: user.enterprise) }
      let!(:email) { create(:email, enterprise: user.enterprise, mailer_name: 'poll_mailer', mailer_method: 'invitation', content: "<p>Hello %{user.name},</p>\r\n\r\n<p>You are invited to participate in the following online in Diverst: %{survey.title}</p>\r\n\r\n<p>%{click_here} to provide feedback and offer your thoughts and suggestions.</p>\r\n", subject: "You are Invited to participate in a '%{survey.title}' survey") }
      let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
      let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'survey.title')) }
      let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }
      let!(:mail) { described_class.invitation(poll, user).deliver_now }

      it 'renders the redirect_email_contact' do
        expect(mail.to).to eq([enterprise.redirect_email_contact])
      end
    end
  end

  context 'when enterprise wants to redirect emails but redirect_email_contact is to blank' do
    describe '#invitation' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
      let(:user) { create :user, enterprise: enterprise }
      let(:poll) { create :poll }
      let!(:group) { create :group }
      let!(:groups_poll) { create :groups_poll, poll: poll, group: group }
      let!(:custom_text) { create(:custom_text, erg: 'BRG', enterprise: user.enterprise) }
      let!(:email) { create(:email, enterprise: user.enterprise, mailer_name: 'poll_mailer', mailer_method: 'invitation', content: "<p>Hello %{user.name},</p>\r\n\r\n<p>You are invited to participate in the following online in Diverst: %{survey.title}</p>\r\n\r\n<p>%{click_here} to provide feedback and offer your thoughts and suggestions.</p>\r\n", subject: "You are Invited to participate in a '%{survey.title}' survey") }
      let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
      let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'survey.title')) }
      let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let!(:mail) { described_class.invitation(poll, user).deliver_now }

      it 'renders the fallback_email' do
        expect(mail.to).to eq([fallback_email])
      end
    end
  end

  context 'when enterprise wants to stop all emails' do
    describe '#invitation' do
      let(:enterprise) { create(:enterprise, disable_emails: true) }
      let(:user) { create :user, enterprise: enterprise }
      let(:poll) { create :poll }
      let!(:group) { create :group }
      let!(:groups_poll) { create :groups_poll, poll: poll, group: group }
      let!(:custom_text) { create(:custom_text, erg: 'BRG', enterprise: user.enterprise) }
      let!(:mail) { described_class.invitation(poll, user).deliver_now }

      it 'renders null mail object' do
        expect(mail).to be(nil)
      end
    end
  end
end
