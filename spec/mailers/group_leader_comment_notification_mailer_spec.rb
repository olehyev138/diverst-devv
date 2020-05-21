require 'rails_helper'

RSpec.describe GroupLeaderCommentNotificationMailer, type: :mailer do
  let!(:leader) { create(:user) }
  let!(:group) { create(:group, enterprise: leader.enterprise, pending_users: 'enabled') }
  let!(:user_group) { create(:user_group, group: group, user: leader, accepted_member: true) }
  let!(:group_leader) { create(:group_leader, group: group, user: leader) }

  let!(:mail) { described_class.notification(group, leader, 1).deliver_now }

  describe '#notification' do
    it 'the email is queued' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end

    it 'renders the subject' do
      expect(mail.subject).to eq "1 Pending Comment(s) for #{group.name.titleize}"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([leader.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@diverst.com'])
    end

    it 'shows a message with number of pending comments in group' do
      expect(mail.body.encoded).to include("#{group.name} has 1 pending comment")
    end

    it 'includes a link to the news feed' do
      expect(mail.body.encoded).to include("groups/#{group.id}/posts")
    end
  end

  context 'when enterprise wants to redirect emails and redirect_email_contact is set' do
    describe '#notification' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
      let!(:leader) { create(:user, enterprise: enterprise) }
      let!(:group) { create(:group, enterprise: leader.enterprise, pending_users: 'enabled') }
      let!(:user_group) { create(:user_group, group: group, user: leader, accepted_member: true) }
      let!(:group_leader) { create(:group_leader, group: group, user: leader) }

      let!(:mail) { described_class.notification(group, leader, 1).deliver_now }

      it 'renders the redirect_email_contact' do
        expect(mail.to).to eq([enterprise.redirect_email_contact])
      end
    end
  end

  context 'when enterprise wants to redirect emails but redirect_email_contact is to blank' do
    describe '#notification' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
      let!(:leader) { create(:user, enterprise: enterprise) }
      let!(:group) { create(:group, enterprise: leader.enterprise, pending_users: 'enabled') }
      let!(:user_group) { create(:user_group, group: group, user: leader, accepted_member: true) }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let!(:group_leader) { create(:group_leader, group: group, user: leader) }

      let!(:mail) { described_class.notification(group, leader, 1).deliver_now }

      it 'renders the redirect_email_contact' do
        expect(mail.to).to eq([fallback_email])
      end
    end
  end

  context 'when enterprise wants to stop all emails' do
    describe '#approve_request' do
      let(:enterprise) { create(:enterprise, disable_emails: true) }
      let!(:leader) { create(:user, enterprise: enterprise) }
      let!(:group) { create(:group, enterprise: leader.enterprise, pending_users: 'enabled') }
      let!(:user_group) { create(:user_group, group: group, user: leader, accepted_member: true) }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let!(:group_leader) { create(:group_leader, group: group, user: leader) }

      let!(:mail) { described_class.notification(group, leader, 1).deliver_now }

      it 'renders null mail object' do
        expect(mail).to be(nil)
      end
    end
  end
end
