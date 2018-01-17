require 'rails_helper'

RSpec.describe GroupLeaderNotificationsJob, type: :job do
  include ActiveJob::TestHelper

  let!(:user){ create(:user) }
  let!(:group){ create(:group, :pending_users => "enabled") }
  let!(:user_group) {create(:user_group, :group => group, :user => user, :accepted_member => true)}
  let!(:group_leader){ create(:group_leader, :group => group, :user => user) }

  context "with daily frequency" do
    context "when there are no pending members" do
      it "does not send an email of notification to leader" do
        expect(GroupLeaderNotificationMailer).to_not receive(:notification)
        subject.perform(group)
      end
    end

    context "when there are pending members" do
      it "does not send an email of notification to leader because notifications_enabled is false" do
        member = create(:user)
        create(:user_group, :group => group, :user => member, :accepted_member => false)
        expect(GroupLeaderNotificationMailer).to_not receive(:notification)
        subject.perform(group)
      end

      it "sends an email of notification to leader because notifications_enabled is true" do
        member = create(:user)
        create(:user_group, :group => group, :user => member, :accepted_member => false)
        group_leader.notifications_enabled = true
        group_leader.save
        mailer = double("mailer")

        expect(GroupLeaderNotificationMailer).to receive(:notification){ mailer }
        expect(mailer).to receive(:deliver_now)

        subject.perform(group)
      end
    end
  end
end
