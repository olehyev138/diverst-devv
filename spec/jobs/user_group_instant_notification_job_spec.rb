require 'rails_helper'

RSpec.describe UserGroupInstantNotificationJob, type: :job do
  include ActiveJob::TestHelper

  let!(:user){ create(:user) }
  let!(:group){ create(:group, members: [user]) }

  context "when user accept to receive real time notifications" do
    let!(:user_group){
      create(:user_group, group: group, user: user, notifications_frequency: UserGroup.notifications_frequencies[:real_time])
    }

    it "send an email of notification to members of group with real_time setting" do
      mailer = double("mailer")
      expect(UserGroupMailer).to receive(:notification)
        .with(user, [{ group: group, messages_count: 1, news_count: 0 }]){ mailer }
      expect(mailer).to receive(:deliver_now)

      subject.perform(group, messages_count: 1)
    end
  end

  context "when user does not accept to receive real time notifications" do
    let!(:user_group){
      create(:user_group, group: group, user: user, notifications_frequency: UserGroup.notifications_frequencies[:disabled])
    }

    it "send an email of notification to members of group with real_time setting" do
      expect(UserGroupMailer).to_not receive(:notification)
      subject.perform(group)
    end
  end
end
