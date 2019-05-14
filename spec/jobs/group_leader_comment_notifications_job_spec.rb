require 'rails_helper'

RSpec.describe GroupLeaderCommentNotificationsJob, type: :job do
  include ActiveJob::TestHelper

  let!(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }
  let!(:group) { create(:group, enterprise: enterprise, pending_users: 'enabled') }
  let!(:user_group) { create(:user_group, group: group, user: user, accepted_member: true) }
  let!(:group_leader) { create(:group_leader, group: group, user: user) }

  context 'with daily frequency' do
    context 'when there are no pending comments' do
      it 'does not send an email of notification to leader when enable_pending_comments is false' do
        expect(GroupLeaderCommentNotificationMailer).to_not receive(:notification)
        subject.perform(group.id)
      end

      it 'does not send an email of notification to leader when enable_pending_comments is true' do
        enterprise.enable_pending_comments = true
        enterprise.save!
        expect(GroupLeaderCommentNotificationMailer).to_not receive(:notification)
        subject.perform(group.id)
      end
    end

    context 'when there are pending comments' do
      it 'does not send an email of notification to leader because enable_pending_comments is false and pending_post_notifications_enabled is false' do
        group_message = create(:group_message, group: group)
        create(:group_message_comment, message: group_message, approved: false)
        expect(GroupLeaderCommentNotificationMailer).to_not receive(:notification)
        subject.perform(group.id)
      end

      it 'does not send an email of notification to leader because enable_pending_comments is true and pending_post_notifications_enabled is false' do
        enterprise.enable_pending_comments = true
        enterprise.save!
        group_message = create(:group_message, group: group)
        create(:group_message_comment, message: group_message, approved: false)
        expect(GroupLeaderCommentNotificationMailer).to_not receive(:notification)
        subject.perform(group.id)
      end

      it 'sends an email of notification to leader because enable_pending_comments is true and pending_post_notifications_enabled is true' do
        enterprise.enable_pending_comments = true
        enterprise.save!
        group_message = create(:group_message, group: group)
        create(:group_message_comment, message: group_message, approved: false)
        group_leader.pending_comments_notifications_enabled = true
        group_leader.save
        mailer = double('mailer')

        expect(GroupLeaderCommentNotificationMailer).to receive(:notification) { mailer }
        expect(mailer).to receive(:deliver_now)

        subject.perform(group.id)
      end
    end
  end
end
