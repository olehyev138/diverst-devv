require 'rails_helper'

RSpec.describe UserGroupNotificationJob, type: :job do
  include ActiveJob::TestHelper

  let!(:user){ create(:user) }
  let!(:group){ create(:group) }

  context "when there is no messages or news" do
    it "does no send an email of notification to user" do
      expect(UserGroupMailer).to_not receive(:notification)
      subject.perform
    end
  end

  context "when there is new messages or news" do
    let!(:user_group){ create(:user_group, user: user, group: group, enable_notification: true) }
    let!(:group_message){ create(:group_message, group: group, updated_at: Date.yesterday) }
    let!(:another_group_message){ create(:group_message, group: group, updated_at: Date.today) }
    let!(:news_link){ create(:news_link, group: group, updated_at: Date.yesterday) }
    let!(:another_news_link){ create(:news_link, group: group, updated_at: Date.today) }

    it "sends an email of notification to user" do
      Timecop.freeze(Date.today) do
        mailer = double("mailer")
        expect(UserGroupMailer).to receive(:notification)
          .with(user, [{ group: group, messages_count: 1, news_count: 1 }]){ mailer }
        expect(mailer).to receive(:deliver_now)
        subject.perform
      end
    end
  end
end
