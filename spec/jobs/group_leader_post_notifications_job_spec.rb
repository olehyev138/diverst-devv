require 'rails_helper'

RSpec.describe GroupLeaderPostNotificationsJob, type: :job do
  include ActiveJob::TestHelper

  let!(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }
  let!(:group) { create(:group, enterprise: enterprise, pending_users: 'enabled') }
  let!(:user_group) { create(:user_group, group: group, user: user, accepted_member: true) }
  let!(:group_leader) { create(:group_leader, group: group, user: user) }

  context 'with daily frequency' do
    context 'when there are no pending posts' do
      it 'does not send an email of notification to leader' do
        expect(GroupLeaderPostNotificationMailer).to_not receive(:notification)
        subject.perform(group.id)
      end
    end

    context 'when there are pending posts' do
      it 'does not send an email of notification to leader because pending_post_notifications_enabled is false' do
        news_link = create(:news_link, group: group)
        expect(GroupLeaderPostNotificationMailer).to_not receive(:notification)
        subject.perform(group.id)
      end

      # TODO Fix MySQL errors on CircleCI with these tests
      it 'sends an email of notification to leader because pending_post_notifications_enabled is true' do
        pending
        news_link = create(:news_link, group: group)
        news_link.news_feed_link.approved = false
        news_link.news_feed_link.save!

        group_leader.pending_posts_notifications_enabled = true
        group_leader.save
        mailer = double('mailer')

        expect(GroupLeaderPostNotificationMailer).to receive(:notification) { mailer }
        expect(mailer).to receive(:deliver_now)

        subject.perform(group.id)
      end
    end
  end
end
