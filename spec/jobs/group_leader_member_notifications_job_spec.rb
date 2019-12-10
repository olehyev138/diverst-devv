require 'rails_helper'

RSpec.describe GroupLeaderMemberNotificationsJob, type: :job do
  include ActiveJob::TestHelper

  let!(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise, user_role: enterprise.user_roles.where(role_type: 'admin').first) }
  let!(:group) { create(:group, enterprise: enterprise, pending_users: 'enabled') }
  let!(:user_group) { create(:user_group, group: group, user: user, accepted_member: true) }
  let!(:group_leader) { create(:group_leader, group: group, user: user, user_role: enterprise.user_roles.where(role_type: 'group').first) }

  context 'with daily frequency' do
    context 'when there are no pending members' do
      it 'does not send an email of notification to leader' do
        expect(GroupLeaderMemberNotificationMailer).to_not receive(:notification)
        subject.perform(group.id)
      end
    end

    context 'when there are pending members' do
      # TODO Fix MySQL errors on CircleCI with these tests
      xit 'does not send an email of notification to leader because pending_member_notifications_enabled is false' do
        enterprise = create(:enterprise)
        member = create(:user, enterprise: enterprise, user_role: enterprise.user_roles.where(role_type: 'admin').first)
        create(:user_group, group: group, user: member, accepted_member: false)
        expect(GroupLeaderMemberNotificationMailer).to_not receive(:notification)
        subject.perform(group.id)
      end

      xit 'sends an email of notification to leader because pending_member_notifications_enabled is true and there is a pending member' do
        enterprise = create(:enterprise)
        member = create(:user, enterprise: enterprise, user_role: enterprise.user_roles.where(role_type: 'admin').first)
        create(:user_group, group: group, user: member, accepted_member: false)
        group_leader.pending_member_notifications_enabled = true
        group_leader.save
        mailer = double('mailer')

        expect(GroupLeaderMemberNotificationMailer).to receive(:notification) { mailer }
        expect(mailer).to receive(:deliver_now)

        subject.perform(group.id)
      end
    end
  end
end
