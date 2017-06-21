require 'rails_helper'

RSpec.describe UserGroupNotificationJob, type: :job do
  include ActiveJob::TestHelper

  let!(:user){ create(:user) }
  let!(:group){ create(:group) }

  context "with daily frequency" do
    context "when there is no messages or news" do
      it "does no send an email of notification to user" do
        expect(UserGroupMailer).to_not receive(:notification)
        subject.perform('daily')
      end
    end

    context "when there is new messages or news" do
      let!(:user_group){ create(:user_group, user: user, group: group, notifications_frequency: UserGroup.notifications_frequencies[:daily]) }
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
          subject.perform('daily')
        end
      end
    end
  end

  context "with weekly frequency" do
    context "and there is no messages or news" do
      it "does no send an email of notification to user" do
        Timecop.freeze(Date.today.next_week(:monday)) do
          expect(UserGroupMailer).to_not receive(:notification)
          subject.perform('weekly')
        end
      end
    end

    context "and there is new messages or news" do
      let!(:user_group){ create(:user_group, user: user, group: group, notifications_frequency: UserGroup.notifications_frequencies[:weekly]) }
      let!(:group_message){ create(:group_message, group: group, updated_at: Date.today - 8.days) }
      let!(:another_group_message){ create(:group_message, group: group, updated_at: Date.today) }
      let!(:news_link){ create(:news_link, group: group, updated_at: Date.today - 8.days) }
      let!(:another_news_link){ create(:news_link, group: group, updated_at: Date.today) }

      it "sends an email of notification to user" do
        Timecop.freeze(Date.today.next_week(:monday)) do
          mailer = double("mailer")
          expect(UserGroupMailer).to receive(:notification)
            .with(user, [{ group: group, messages_count: 1, news_count: 1 }]){ mailer }
          expect(mailer).to receive(:deliver_now)
          subject.perform('weekly')
        end
      end
    end
  end
end
