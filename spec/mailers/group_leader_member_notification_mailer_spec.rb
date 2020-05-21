require 'rails_helper'

RSpec.describe GroupLeaderMemberNotificationMailer, type: :mailer do
  let!(:leader) { create(:user) }
  let!(:group) { create(:group, pending_users: 'enabled', enterprise: leader.enterprise) }
  let!(:user_group) { create(:user_group, group: group, user: leader, accepted_member: true) }

  let!(:group_leader) { create(:group_leader, group: group, user: leader, user_role: group.enterprise.user_roles.where(role_name: 'group_leader').first) }
  let!(:email) { create(:email, enterprise: leader.enterprise, mailer_name: 'group_leader_member_notification_mailer', mailer_method: 'notification', content: "<p>Hello %{user.name},</p>\r\n\r\n<p>%{group.name} has %{count} pending member(s). Click below to view them and accept/deny group membership.</p>\r\n\r\n<p>%{click_here} to view pending members.</p>\r\n", subject: '%{count} Pending Member(s) for %{group.name}') }
  let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
  let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'group.name'), titleize: true) }
  let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'count')) }
  let!(:email_variable_4) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }

  let!(:mail) { described_class.notification(group, leader, 1).deliver_now }

  describe '#notification' do
    it 'the email is queued' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end

    it 'renders the subject' do
      expect(mail.subject).to eq " Pending Member(s) for #{group.name.titleize}"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([leader.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@diverst.com'])
    end

    it 'shows a message with number of pending members in group' do
      expect(mail.body.encoded).to include("#{group.name.titleize} has  pending member(s)")
    end
  end

  context 'when enterprise wants to redirect emails and redirect_email_contact is set' do
    describe '#notification' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
      let!(:leader) { create(:user, enterprise: enterprise) }
      let!(:group) { create(:group, pending_users: 'enabled', enterprise: leader.enterprise) }
      let!(:user_group) { create(:user_group, group: group, user: leader, accepted_member: true) }

      let!(:group_leader) { create(:group_leader, group: group, user: leader, user_role: group.enterprise.user_roles.where(role_name: 'group_leader').first) }
      let!(:email) { create(:email, enterprise: leader.enterprise, mailer_name: 'group_leader_member_notification_mailer', mailer_method: 'notification', content: "<p>Hello %{user.name},</p>\r\n\r\n<p>%{group.name} has %{count} pending member(s). Click below to view them and accept/deny group membership.</p>\r\n\r\n<p>%{click_here} to view pending members.</p>\r\n", subject: '%{count} Pending Member(s) for %{group.name}') }
      let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
      let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'group.name'), titleize: true) }
      let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'count')) }
      let!(:email_variable_4) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }

      let!(:mail) { described_class.notification(group, leader, 1).deliver_now }

      it 'renders the redirect_email_contact email' do
        expect(mail.to).to eq([enterprise.redirect_email_contact])
      end
    end
  end

  context 'when enterprise wants to redirect emails but redirect_email_contact is to blank' do
    describe '#notification' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
      let!(:leader) { create(:user, enterprise: enterprise) }
      let!(:group) { create(:group, pending_users: 'enabled', enterprise: leader.enterprise) }
      let!(:user_group) { create(:user_group, group: group, user: leader, accepted_member: true) }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let!(:group_leader) { create(:group_leader, group: group, user: leader, user_role: group.enterprise.user_roles.where(role_name: 'group_leader').first) }
      let!(:email) { create(:email, enterprise: leader.enterprise, mailer_name: 'group_leader_member_notification_mailer', mailer_method: 'notification', content: "<p>Hello %{user.name},</p>\r\n\r\n<p>%{group.name} has %{count} pending member(s). Click below to view them and accept/deny group membership.</p>\r\n\r\n<p>%{click_here} to view pending members.</p>\r\n", subject: '%{count} Pending Member(s) for %{group.name}') }
      let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
      let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'group.name'), titleize: true) }
      let!(:email_variable_3) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'count')) }
      let!(:email_variable_4) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'click_here')) }

      let!(:mail) { described_class.notification(group, leader, 1).deliver_now }

      it 'renders the fallback_email' do
        expect(mail.to).to eq([fallback_email])
      end
    end
  end

  context 'when enterprise wants to stop all emails' do
    describe '#notification' do
      let(:enterprise) { create(:enterprise, disable_emails: true) }
      let!(:leader) { create(:user, enterprise: enterprise) }
      let!(:group) { create(:group, pending_users: 'enabled', enterprise: leader.enterprise) }
      let!(:user_group) { create(:user_group, group: group, user: leader, accepted_member: true) }
      let!(:group_leader) { create(:group_leader, group: group, user: leader, user_role: group.enterprise.user_roles.where(role_name: 'group_leader').first) }
      let!(:mail) { described_class.notification(group, leader, 1).deliver_now }

      it 'renders null mail object' do
        expect(mail).to be(nil)
      end
    end
  end
end
