require 'rails_helper'

RSpec.describe UserGroupNotificationJob, type: :job do
  include ActiveJob::TestHelper

  let!(:user){ create(:user) }
  let!(:group){ create(:group, pending_users: "disabled") }
  
  context "with hourly frequency" do
    context "when there is no messages or news" do
      it "does no send an email of notification to user" do
        expect(UserGroupMailer).to_not receive(:notification)
        subject.perform('hourly')
      end
    end

    context "when there is new messages or news" do
      let(:previous_hour) { 1.hour.ago }
      let(:next_hour) { Time.now }

      let!(:user_group){ create(:user_group, user: user, group: group, notifications_frequency: UserGroup.notifications_frequencies[:hourly]) }
      let!(:group_message){ create(:group_message, group: group, updated_at: previous_hour, owner: user) }
      let!(:another_group_message){ create(:group_message, group: group, updated_at: next_hour, owner: user) }
      let!(:group_event) { create(:initiative, owner_group: group, updated_at: previous_hour, owner: user) }
      let!(:another_group_event) { create(:initiative, owner_group: group, updated_at: next_hour, owner: user) }
      let!(:news_link){ create(:news_link, group: group, updated_at: previous_hour, author: user) }
      let!(:another_news_link){ create(:news_link, group: group, updated_at: next_hour, author: user) }
      let!(:social_link){ create(:social_link, group: group, updated_at: previous_hour, author: user) }
      let!(:another_social_link){ create(:social_link, group: group, updated_at: next_hour, author: user) }
      
      it "sends an email of notification to user" do
        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double("mailer")
          expect(UserGroupMailer).to receive(:notification)
            .with(user, [{ group: group, events_count: 1, messages_count: 1, news_count: 1, social_links_count: 1 }]){ mailer }
          expect(mailer).to receive(:deliver_now)
          subject.perform('hourly')
        end
      end
    end
    
    context "when there is new messages or news and segments" do
      let(:previous_hour) { 1.hour.ago }
      let(:next_hour) { Time.now }

      let!(:user_group){ create(:user_group, user: user, group: group, notifications_frequency: UserGroup.notifications_frequencies[:hourly]) }
      let!(:group_message){ create(:group_message, group: group, updated_at: previous_hour, owner: user) }
      let!(:another_group_message){ create(:group_message, group: group, updated_at: next_hour, owner: user) }
      let!(:group_event) { create(:initiative, owner_group: group, updated_at: previous_hour, owner: user) }
      let!(:another_group_event) { create(:initiative, owner_group: group, updated_at: next_hour, owner: user) }
      let!(:news_link){ create(:news_link, group: group, updated_at: previous_hour, author: user) }
      let!(:another_news_link){ create(:news_link, group: group, updated_at: next_hour, author: user) }
      let!(:social_link){ create(:social_link, group: group, updated_at: previous_hour, author: user) }
      let!(:another_social_link){ create(:social_link, group: group, updated_at: next_hour, author: user) }
      
      it "sends an email of notification to user when user is in segment and items are not in segments" do
        segment = create(:segment, :groups => [group])
        create(:users_segment, :user => user, :segment => segment)
      
        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double("mailer")
          expect(UserGroupMailer).to receive(:notification)
            .with(user, [{ group: group, events_count: 1, messages_count: 1, news_count: 1, social_links_count: 1 }]){ mailer }
          expect(mailer).to receive(:deliver_now)
          subject.perform('hourly')
        end
      end
      
      it "sends an email of notification to user when user is in segment and items are in segment" do
        segment = create(:segment, :groups => [group])
        create(:users_segment, :user => user, :segment => segment)
        
        create(:news_link_segment, :news_link => news_link, :segment => segment)
        create(:social_link_segment, :social_link => social_link, :segment => segment)
        create(:group_messages_segment, :group_message => group_message, :segment => segment)
        
        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double("mailer")
          expect(UserGroupMailer).to receive(:notification)
            .with(user, [{ group: group, events_count: 1, messages_count: 1, news_count: 1, social_links_count: 1 }]){ mailer }
          expect(mailer).to receive(:deliver_now)
          subject.perform('hourly')
        end
      end
      
      it "send an email of notification only for events to user when user is not in segment and items are in segment" do
        segment = create(:segment, :groups => [group])
        
        create(:news_link_segment, :news_link => news_link, :segment => segment)
        create(:news_link_segment, :news_link => another_news_link, :segment => segment)
        create(:social_link_segment, :social_link => social_link, :segment => segment)
        create(:social_link_segment, :social_link => another_social_link, :segment => segment)
        create(:group_messages_segment, :group_message => group_message, :segment => segment)
        create(:group_messages_segment, :group_message => another_group_message, :segment => segment)
        
        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double("mailer")
          expect(UserGroupMailer).to receive(:notification)
            .with(user, [{ group: group, events_count: 1, messages_count: 0, news_count: 0, social_links_count: 0 }]){ mailer }
          expect(mailer).to receive(:deliver_now)
          subject.perform('hourly')
        end
      end
      
      it "does not send an email of notification only for events to user when user is not in segment and items are in segment" do
        segment = create(:segment, :groups => [group])
        
        create(:news_link_segment, :news_link => news_link, :segment => segment)
        create(:news_link_segment, :news_link => another_news_link, :segment => segment)
        create(:social_link_segment, :social_link => social_link, :segment => segment)
        create(:social_link_segment, :social_link => another_social_link, :segment => segment)
        create(:group_messages_segment, :group_message => group_message, :segment => segment)
        create(:group_messages_segment, :group_message => another_group_message, :segment => segment)
        
        Initiative.destroy_all
        
        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double("mailer")
          expect(UserGroupMailer).to_not receive(:notification)
          expect(mailer).to_not receive(:deliver_now)
          subject.perform('hourly')
        end
      end
    end
  end

  context "with daily frequency" do
    context "when there is no messages or news" do
      it "does no send an email of notification to user" do
        expect(UserGroupMailer).to_not receive(:notification)
        subject.perform('daily')
      end
    end

    context "when there is new messages or news" do
      let(:yesterday) { Date.today - 1.day }
      let(:today) { Date.today }

      let!(:user_group){ create(:user_group, user: user, group: group, notifications_frequency: UserGroup.notifications_frequencies[:daily]) }
      let!(:group_message){ create(:group_message, group: group, updated_at: yesterday, owner: user) }
      let!(:another_group_message){ create(:group_message, group: group, updated_at: today, owner: user) }
      let!(:group_event) { create(:initiative, owner_group: group, updated_at: yesterday, owner: user) }
      let!(:news_link){ create(:news_link, group: group, updated_at: yesterday, author: user) }
      let!(:another_news_link){ create(:news_link, group: group, updated_at: today, author: user) }
      let!(:social_link){ create(:social_link, group: group, updated_at: yesterday, author: user) }
      let!(:another_social_link){ create(:social_link, group: group, updated_at: today, author: user) }
      
      it "sends an email of notification to user" do
        Timecop.freeze(Date.today) do
          mailer = double("mailer")
          expect(UserGroupMailer).to receive(:notification)
            .with(user, [{ group: group, events_count: 1, messages_count: 1, news_count: 1, social_links_count: 1 }]){ mailer }
          expect(mailer).to receive(:deliver_now)
          subject.perform('daily')
        end
      end
      
      it "sends an email of notification to user when user is in segment and items are not in segments" do
        segment = create(:segment, :groups => [group])
        create(:users_segment, :user => user, :segment => segment)
      
        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double("mailer")
          expect(UserGroupMailer).to receive(:notification)
            .with(user, [{ group: group, events_count: 1, messages_count: 1, news_count: 1, social_links_count: 1 }]){ mailer }
          expect(mailer).to receive(:deliver_now)
          subject.perform('daily')
        end
      end
      
      it "sends an email of notification to user when user is in segment and items are in segment" do
        segment = create(:segment, :groups => [group])
        create(:users_segment, :user => user, :segment => segment)
        
        create(:news_link_segment, :news_link => news_link, :segment => segment)
        create(:social_link_segment, :social_link => social_link, :segment => segment)
        create(:group_messages_segment, :group_message => group_message, :segment => segment)
        
        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double("mailer")
          expect(UserGroupMailer).to receive(:notification)
            .with(user, [{ group: group, events_count: 1, messages_count: 1, news_count: 1, social_links_count: 1 }]){ mailer }
          expect(mailer).to receive(:deliver_now)
          subject.perform('daily')
        end
      end
      
      it "send an email of notification only for events to user when user is not in segment and items are in segment" do
        segment = create(:segment, :groups => [group])
        
        create(:news_link_segment, :news_link => news_link, :segment => segment)
        create(:news_link_segment, :news_link => another_news_link, :segment => segment)
        create(:social_link_segment, :social_link => social_link, :segment => segment)
        create(:social_link_segment, :social_link => another_social_link, :segment => segment)
        create(:group_messages_segment, :group_message => group_message, :segment => segment)
        create(:group_messages_segment, :group_message => another_group_message, :segment => segment)
        
        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double("mailer")
          expect(UserGroupMailer).to receive(:notification)
            .with(user, [{ group: group, events_count: 1, messages_count: 0, news_count: 0, social_links_count: 0 }]){ mailer }
          expect(mailer).to receive(:deliver_now)
          subject.perform('daily')
        end
      end
      
      it "does not send an email of notification only for events to user when user is not in segment and items are in segment" do
        segment = create(:segment, :groups => [group])
        
        create(:news_link_segment, :news_link => news_link, :segment => segment)
        create(:news_link_segment, :news_link => another_news_link, :segment => segment)
        create(:social_link_segment, :social_link => social_link, :segment => segment)
        create(:social_link_segment, :social_link => another_social_link, :segment => segment)
        create(:group_messages_segment, :group_message => group_message, :segment => segment)
        create(:group_messages_segment, :group_message => another_group_message, :segment => segment)
        
        Initiative.destroy_all
        
        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double("mailer")
          expect(UserGroupMailer).to_not receive(:notification)
          expect(mailer).to_not receive(:deliver_now)
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
      let(:week_ago) { 6.days.ago }
      let(:today) { Date.today }

      let!(:user_group){ create(:user_group, user: user, group: group, notifications_frequency: UserGroup.notifications_frequencies[:weekly]) }
      let!(:group_message){ create(:group_message, group: group, updated_at: week_ago, owner: user) }
      let!(:another_group_message){ create(:group_message, group: group, updated_at: today, owner: user) }
      let!(:group_event) { create(:initiative, owner_group: group, updated_at: week_ago, owner: user) }
      let!(:another_group_event) { create(:initiative, owner_group: group, updated_at: today, owner: user) }
      let!(:news_link){ create(:news_link, group: group, updated_at: week_ago, author: user) }
      let!(:another_news_link){ create(:news_link, group: group, updated_at: today, author: user) }
      let!(:social_link){ create(:social_link, group: group, updated_at: week_ago, author: user) }
      let!(:another_social_link){ create(:social_link, group: group, updated_at: today, author: user) }

      it "sends an email of notification to user" do
        mailer = double("mailer")
        expect(UserGroupMailer).to receive(:notification)
          .with(user, [{ group: group, events_count: 1, messages_count: 1, news_count: 1, social_links_count: 1 }]){ mailer }
        expect(mailer).to receive(:deliver_now)
        subject.perform('weekly')
      end
      
      it "sends an email of notification to user when user is in segment and items are not in segments" do
        segment = create(:segment, :groups => [group])
        create(:users_segment, :user => user, :segment => segment)
      
        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double("mailer")
          expect(UserGroupMailer).to receive(:notification)
            .with(user, [{ group: group, events_count: 1, messages_count: 1, news_count: 1, social_links_count: 1 }]){ mailer }
          expect(mailer).to receive(:deliver_now)
          subject.perform('weekly')
        end
      end
      
      it "sends an email of notification to user when user is in segment and items are in segment" do
        segment = create(:segment, :groups => [group])
        create(:users_segment, :user => user, :segment => segment)
        
        create(:news_link_segment, :news_link => news_link, :segment => segment)
        create(:social_link_segment, :social_link => social_link, :segment => segment)
        create(:group_messages_segment, :group_message => group_message, :segment => segment)
        
        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double("mailer")
          expect(UserGroupMailer).to receive(:notification)
            .with(user, [{ group: group, events_count: 1, messages_count: 1, news_count: 1, social_links_count: 1 }]){ mailer }
          expect(mailer).to receive(:deliver_now)
          subject.perform('weekly')
        end
      end
      
      it "send an email of notification only for events to user when user is not in segment and items are in segment" do
        segment = create(:segment, :groups => [group])
        
        create(:news_link_segment, :news_link => news_link, :segment => segment)
        create(:news_link_segment, :news_link => another_news_link, :segment => segment)
        create(:social_link_segment, :social_link => social_link, :segment => segment)
        create(:social_link_segment, :social_link => another_social_link, :segment => segment)
        create(:group_messages_segment, :group_message => group_message, :segment => segment)
        create(:group_messages_segment, :group_message => another_group_message, :segment => segment)
        
        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double("mailer")
          expect(UserGroupMailer).to receive(:notification)
            .with(user, [{ group: group, events_count: 1, messages_count: 0, news_count: 0, social_links_count: 0 }]){ mailer }
          expect(mailer).to receive(:deliver_now)
          subject.perform('weekly')
        end
      end
      
      it "does not send an email of notification only for events to user when user is not in segment and items are in segment" do
        segment = create(:segment, :groups => [group])
        
        create(:news_link_segment, :news_link => news_link, :segment => segment)
        create(:news_link_segment, :news_link => another_news_link, :segment => segment)
        create(:social_link_segment, :social_link => social_link, :segment => segment)
        create(:social_link_segment, :social_link => another_social_link, :segment => segment)
        create(:group_messages_segment, :group_message => group_message, :segment => segment)
        create(:group_messages_segment, :group_message => another_group_message, :segment => segment)
        
        Initiative.destroy_all
        
        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double("mailer")
          expect(UserGroupMailer).to_not receive(:notification)
          expect(mailer).to_not receive(:deliver_now)
          subject.perform('weekly')
        end
      end
    end
  end
end
