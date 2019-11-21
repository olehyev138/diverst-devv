require 'rails_helper'

RSpec.describe UserGroupNotificationJob, type: :job do
  include ActiveJob::TestHelper

  let!(:enterprise) { create(:enterprise, enable_social_media: true) }
  let!(:user) { create(:user, enterprise: enterprise) }
  let!(:group) { create(:group, pending_users: 'disabled', enterprise: enterprise) }
  let!(:second_group) { create(:group, pending_users: 'disabled') }

  context '#get_users_to_mail' do
    before(:all) do
      @enterprise = create(:enterprise, enable_social_media: true)

      users = create_list(:user, 500, enterprise: @enterprise, groups_notifications_frequency: 'weekly')
      groups = create_list(:group, 25, enterprise: @enterprise)

      users.each do |user|
        groups_to_be_a_member_of = groups.sample(rand(0..5))
        groups_to_be_a_member_of.each do |group|
          create(:user_group, user: user, group: group)
        end
      end
    end

    it 'returns nil if notification frequency is invalid' do
      expect(subject.get_users_to_mail(@enterprise.id, 'invalid')).to eq nil
      expect(subject.get_users_to_mail(@enterprise.id, nil)).to eq nil
      expect(subject.get_users_to_mail(@enterprise.id, 3)).to eq nil
      expect(subject.get_users_to_mail(@enterprise.id, [])).to eq nil
      expect(subject.get_users_to_mail(@enterprise.id, {})).to eq nil
    end

    context 'returns the correct users' do
      before do
        @users = subject.get_users_to_mail(@enterprise.id, 'weekly')
      end

      it 'returns a collection of unique users to email' do
        expect(@users.uniq.count).to eq @users.count
      end

      it 'all the users are in a group' do
        all_users_in_groups = true
        @users.find_each do |user|
          all_users_in_groups = false if UserGroup.find_by(user_id: user.id).nil?
        end
        expect(all_users_in_groups).to eq true
      end
    end
  end

  context '#notify_user?(user)' do
    it 'returns true unless last_group_notification_date is set' do
      expect(subject.notify_user?(user)).to eq true
    end

    it 'returns false when last_group_notification_date is set' do
      user.last_group_notification_date = DateTime.now
      expect(subject.notify_user?(user)).to eq false
    end
  end

  context 'with hourly frequency' do
    let!(:user) { create(:user, groups_notifications_frequency: User.groups_notifications_frequencies[:hourly]) }

    context 'when there is no messages or news' do
      it 'does no send an email of notification to user' do
        expect(UserGroupMailer).to_not receive(:notification)
        subject.perform({ notifications_frequency: 'hourly', enterprise_id: user.enterprise_id })
      end
    end

    context 'when there is new messages or news' do
      let(:previous_hour) { 30.minutes.ago.in_time_zone('EST') }
      let(:next_hour) { 2.hours.ago.in_time_zone('EST') }

      let!(:user_group) { create(:user_group, user: user, group: group) }
      let!(:group_message) { create(:group_message, group: group, updated_at: previous_hour, owner: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:another_group_message) { create(:group_message, group: group, updated_at: next_hour, owner: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }

      let!(:group_event) { create(:initiative, owner_group: group, updated_at: previous_hour, owner: user) }
      let!(:another_group_event) { create(:initiative, owner_group: group, updated_at: next_hour, owner: user) }
      let!(:third_group_event) { create(:initiative, owner_group: second_group, updated_at: previous_hour, owner: user) }
      let!(:fourth_group_event) { create(:initiative, owner_group: second_group, updated_at: next_hour, owner: user) }
      let!(:initiative_participating_group) { create(:initiative_participating_group, initiative: third_group_event, group: group) }
      let!(:second_initiative_participating_group) { create(:initiative_participating_group, initiative: fourth_group_event, group: group) }
      let!(:news_link) { create(:news_link, group: group, updated_at: previous_hour, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:another_news_link) { create(:news_link, group: group, updated_at: next_hour, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:social_link) { create(:social_link, group: group, updated_at: previous_hour, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:another_social_link) { create(:social_link, group: group, updated_at: next_hour, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }

      it 'sends an email of notification to user' do
        # Timecop.freeze(Time.now + 30.minutes) do
        mailer = double('mailer')
        expect(UserGroupMailer).to receive(:notification)
          .with(user, [{
                         group: group,
                         events: [group_event],
                         events_count: 1,
                         messages: [group_message],
                         messages_count: 1,
                         news: [news_link],
                         news_count: 1,
                         social_links: [social_link],
                         social_links_count: 1,
                         participating_events: [third_group_event],
                         participating_events_count: 1
                       }]) { mailer }
        expect(mailer).to receive(:deliver_now)
        subject.perform({ notifications_frequency: 'hourly', enterprise_id: user.enterprise_id })
        # end
      end
    end

    context 'when there is new messages or news and segments' do
      let(:previous_hour) { 30.minutes.ago.in_time_zone('UTC') }
      let(:next_hour) { 2.hours.ago.in_time_zone('UTC') }

      let!(:user_group) { create(:user_group, user: user, group: group) }
      let!(:group_message) { create(:group_message, group: group, updated_at: previous_hour, owner: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:another_group_message) { create(:group_message, group: group, updated_at: next_hour, owner: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:group_event) { create(:initiative, owner_group: group, updated_at: previous_hour, owner: user) }
      let!(:another_group_event) { create(:initiative, owner_group: group, updated_at: next_hour, owner: user) }
      let!(:third_group_event) { create(:initiative, owner_group: second_group, updated_at: previous_hour, owner: user) }
      let!(:fourth_group_event) { create(:initiative, owner_group: second_group, updated_at: next_hour, owner: user) }
      let!(:initiative_participating_group) { create(:initiative_participating_group, initiative: third_group_event, group: group) }
      let!(:second_initiative_participating_group) { create(:initiative_participating_group, initiative: fourth_group_event, group: group) }
      let!(:news_link) { create(:news_link, group: group, updated_at: previous_hour, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:another_news_link) { create(:news_link, group: group, updated_at: next_hour, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:social_link) { create(:social_link, group: group, updated_at: previous_hour, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:another_social_link) { create(:social_link, group: group, updated_at: next_hour, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }

      it 'sends an email of notification to user when user is in segment and items are not in segments' do
        segment = create(:segment, groups: [group, second_group])
        create(:users_segment, user: user, segment: segment)

        mailer = double('mailer')
        expect(UserGroupMailer).to receive(:notification)
          .with(user, [{
                         group: group,
                         events: [group_event],
                         events_count: 1,
                         messages: [group_message],
                         messages_count: 1,
                         news: [news_link],
                         news_count: 1,
                         social_links: [social_link],
                         social_links_count: 1,
                         participating_events: [third_group_event],
                         participating_events_count: 1
                       }]) { mailer }
        expect(mailer).to receive(:deliver_now)
        subject.perform({ notifications_frequency: 'hourly', enterprise_id: user.enterprise_id })
      end

      it 'sends an email of notification to user when user is in segment and items are in segment' do
        segment = create(:segment, groups: [group, second_group])
        create(:users_segment, user: user, segment: segment)

        news_link_segment = create(:news_link_segment, segment: segment, news_link: news_link)
        group_messages_segment = create(:group_messages_segment, segment: segment, group_message: group_message)
        social_link_segment = create(:social_link_segment, segment: segment, social_link: social_link)

        create(:news_feed_link_segment, news_feed_link: news_link.news_feed_link, segment: segment)
        create(:news_feed_link_segment, news_feed_link: social_link.news_feed_link, segment: segment)
        create(:news_feed_link_segment, news_feed_link: group_message.news_feed_link, segment: segment)

        mailer = double('mailer')
        expect(UserGroupMailer).to receive(:notification)
          .with(user, [{
                         group: group,
                         events: [group_event],
                         events_count: 1,
                         messages: [group_message],
                         messages_count: 1,
                         news: [news_link],
                         news_count: 1,
                         social_links: [social_link],
                         social_links_count: 1,
                         participating_events: [third_group_event],
                         participating_events_count: 1
                       }]) { mailer }
        expect(mailer).to receive(:deliver_now)
        subject.perform({ notifications_frequency: 'hourly', enterprise_id: user.enterprise_id })
      end

      it 'send an email of notification only for events to user when user is not in segment and items are in segment' do
        segment = create(:segment, groups: [group])

        create(:news_link_segment, news_link: news_link, segment: segment)
        create(:news_link_segment, news_link: another_news_link, segment: segment)
        create(:social_link_segment, social_link: social_link, segment: segment)
        create(:social_link_segment, social_link: another_social_link, segment: segment)
        create(:group_messages_segment, group_message: group_message, segment: segment)
        create(:group_messages_segment, group_message: another_group_message, segment: segment)

        mailer = double('mailer')
        expect(UserGroupMailer).to receive(:notification)
          .with(user, [{
                         group: group,
                         events: [group_event],
                         events_count: 1,
                         messages: [],
                         messages_count: 0,
                         news: [],
                         news_count: 0,
                         social_links: [],
                         social_links_count: 0,
                         participating_events: [third_group_event],
                         participating_events_count: 1
                       }]) { mailer }
        expect(mailer).to receive(:deliver_now)
        subject.perform({ notifications_frequency: 'hourly', enterprise_id: user.enterprise_id })
      end

      it 'does not send an email of notification only for events to user when user is not in segment and items are in segment' do
        segment = create(:segment, groups: [group])

        create(:news_link_segment, news_link: news_link, segment: segment)
        create(:news_link_segment, news_link: another_news_link, segment: segment)
        create(:social_link_segment, social_link: social_link, segment: segment)
        create(:social_link_segment, social_link: another_social_link, segment: segment)
        create(:group_messages_segment, group_message: group_message, segment: segment)
        create(:group_messages_segment, group_message: another_group_message, segment: segment)

        Initiative.destroy_all

        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double('mailer')
          expect(UserGroupMailer).to_not receive(:notification)
          expect(mailer).to_not receive(:deliver_now)
          subject.perform({ notifications_frequency: 'hourly', enterprise_id: user.enterprise_id })
        end
      end
    end
  end

  context 'with daily frequency' do
    let!(:user) { create(:user, groups_notifications_frequency: User.groups_notifications_frequencies[:daily]) }

    context 'when there is no messages or news' do
      it 'does no send an email of notification to user' do
        expect(UserGroupMailer).to_not receive(:notification)
        subject.perform({ notifications_frequency: 'daily', enterprise_id: user.enterprise_id })
      end
    end

    context 'when there is new messages or news' do
      let(:yesterday) { (Date.today - 1.day).in_time_zone('UTC') }
      let(:today) { (Date.today).in_time_zone('UTC') }

      let!(:user_group) { create(:user_group, user: user, group: group) }
      let!(:group_message) { create(:group_message, group: group, updated_at: yesterday, owner: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:another_group_message) { create(:group_message, group: group, updated_at: today, owner: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:group_event) { create(:initiative, owner_group: group, updated_at: yesterday, owner: user) }
      let!(:another_group_event) { create(:initiative, owner_group: group, updated_at: today, owner: user) }
      let!(:third_group_event) { create(:initiative, owner_group: second_group, updated_at: yesterday, owner: user) }
      let!(:fourth_group_event) { create(:initiative, owner_group: second_group, updated_at: today, owner: user) }
      let!(:initiative_participating_group) { create(:initiative_participating_group, initiative: third_group_event, group: group) }
      let!(:second_initiative_participating_group) { create(:initiative_participating_group, initiative: fourth_group_event, group: group) }
      let!(:news_link) { create(:news_link, group: group, updated_at: yesterday, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:another_news_link) { create(:news_link, group: group, updated_at: today, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:social_link) { create(:social_link, group: group, updated_at: yesterday, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:another_social_link) { create(:social_link, group: group, updated_at: today, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }

      # TODO Fix these tests
      xit 'sends an email of notification to user' do
        Timecop.freeze(Date.today) do
          mailer = double('mailer')
          expect(UserGroupMailer).to receive(:notification)
            .with(user, [{
                           group: group,
                           events: [another_group_event],
                           events_count: 1,
                           messages: [another_group_message],
                           messages_count: 1,
                           news: [another_news_link],
                           news_count: 1,
                           social_links: [another_social_link],
                           social_links_count: 1,
                           participating_events: [fourth_group_event],
                           participating_events_count: 1
                         }]) { mailer }
          expect(mailer).to receive(:deliver_now)
          subject.perform({ notifications_frequency: 'daily', enterprise_id: user.enterprise_id })
        end
      end

      xit 'sends an email of notification to user when user is in segment and items are not in segments' do
        segment = create(:segment, groups: [group, second_group])
        create(:users_segment, user: user, segment: segment)

        mailer = double('mailer')
        expect(UserGroupMailer).to receive(:notification)
          .with(user, [{
                         group: group,
                         events: [another_group_event],
                         events_count: 1,
                         messages: [another_group_message],
                         messages_count: 1,
                         news: [another_news_link],
                         news_count: 1,
                         social_links: [another_social_link],
                         social_links_count: 1,
                         participating_events: [fourth_group_event],
                         participating_events_count: 1
                       }]) { mailer }
        expect(mailer).to receive(:deliver_now)
        subject.perform({ notifications_frequency: 'daily', enterprise_id: user.enterprise_id })
      end

      xit 'sends an email of notification to user when user is in segment and items are in segment' do
        segment = create(:segment, groups: [group, second_group])
        create(:users_segment, user: user, segment: segment)

        nl_segment = create(:news_link_segment, news_link: another_news_link, segment: segment)
        sl_segment = create(:social_link_segment, social_link: another_social_link, segment: segment)
        gm_segment = create(:group_messages_segment, group_message: another_group_message, segment: segment)

        mailer = double('mailer')
        expect(UserGroupMailer).to receive(:notification)
          .with(user, [{
                        group: group,
                        events: [another_group_event],
                        events_count: 1,
                        messages: [another_group_message],
                        messages_count: 1,
                        news: [another_news_link],
                        news_count: 1,
                        social_links: [another_social_link],
                        social_links_count: 1,
                        participating_events: [fourth_group_event],
                        participating_events_count: 1
                      }]) { mailer }
        expect(mailer).to receive(:deliver_now)
        subject.perform({ notifications_frequency: 'daily', enterprise_id: user.enterprise_id })
      end

      xit 'send an email of notification only for events to user when user is not in segment and items are in segment' do
        segment = create(:segment, groups: [group, second_group])

        create(:news_link_segment, news_link: news_link, segment: segment)
        create(:news_link_segment, news_link: another_news_link, segment: segment)
        create(:social_link_segment, social_link: social_link, segment: segment)
        create(:social_link_segment, social_link: another_social_link, segment: segment)
        create(:group_messages_segment, group_message: group_message, segment: segment)
        create(:group_messages_segment, group_message: another_group_message, segment: segment)
        mailer = double('mailer')
        expect(UserGroupMailer).to receive(:notification)
          .with(user, [{
                         group: group,
                         events: [another_group_event],
                         events_count: 1,
                         messages: [],
                         messages_count: 0,
                         news: [],
                         news_count: 0,
                         social_links: [],
                         social_links_count: 0,
                         participating_events: [fourth_group_event],
                         participating_events_count: 1
                       }]) { mailer }
        expect(mailer).to receive(:deliver_now)
        subject.perform({ notifications_frequency: 'daily', enterprise_id: user.enterprise_id })
      end

      it 'does not send an email of notification only for events to user when user is not in segment and items are in segment' do
        segment = create(:segment, groups: [group, second_group])

        create(:news_link_segment, news_link: news_link, segment: segment)
        create(:news_link_segment, news_link: another_news_link, segment: segment)
        create(:social_link_segment, social_link: social_link, segment: segment)
        create(:social_link_segment, social_link: another_social_link, segment: segment)
        create(:group_messages_segment, group_message: group_message, segment: segment)
        create(:group_messages_segment, group_message: another_group_message, segment: segment)

        Initiative.destroy_all

        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double('mailer')
          expect(UserGroupMailer).to_not receive(:notification)
          expect(mailer).to_not receive(:deliver_now)
          subject.perform({ notifications_frequency: 'daily', enterprise_id: user.enterprise_id })
        end
      end
    end

    context 'when there is new shared news' do
      let!(:user) { create(:user, groups_notifications_frequency: User.groups_notifications_frequencies[:daily]) }
      let(:yesterday) { Date.today - 1.day }
      let(:today) { Date.today }

      let!(:second_user) { create(:user, enterprise: user.enterprise, groups_notifications_frequency: User.groups_notifications_frequencies[:disabled]) }
      let!(:third_group) { create(:group, enterprise: second_user.enterprise) }

      let!(:user_group) { create(:user_group, user: user, group: group) }
      let!(:second_user_group) { create(:user_group, user: second_user, group: second_group) }


      let!(:group_message) { create(:group_message, group: third_group, updated_at: yesterday, owner: user, news_feed_link_attributes: { news_feed_id: third_group.news_feed.id }) }
      let!(:another_group_message) { create(:group_message, group: third_group, updated_at: today, owner: user, news_feed_link_attributes: { news_feed_id: third_group.news_feed.id }) }
      let!(:group_event) { create(:initiative, owner_group: third_group, updated_at: yesterday, owner: user) }
      let!(:another_group_event) { create(:initiative, owner_group: third_group, updated_at: today, owner: user) }
      let!(:third_group_event) { create(:initiative, owner_group: third_group, updated_at: yesterday, owner: user) }
      let!(:fourth_group_event) { create(:initiative, owner_group: third_group, updated_at: today, owner: user) }
      let!(:initiative_participating_group) { create(:initiative_participating_group, initiative: third_group_event, group: third_group) }
      let!(:second_initiative_participating_group) { create(:initiative_participating_group, initiative: fourth_group_event, group: third_group) }

      # the news link item below showed count as a new item
      let!(:news_link) { create(:news_link, group: third_group, updated_at: yesterday, author: user, news_feed_link_attributes: { news_feed_id: third_group.news_feed.id }) }
      let!(:shared_news_feed_link) { create(:shared_news_feed_link, news_feed: group.news_feed, news_feed_link: news_link.news_feed_link) }

      let!(:another_news_link) { create(:news_link, group: third_group, updated_at: today, author: user, news_feed_link_attributes: { news_feed_id: third_group.news_feed.id }) }
      let!(:social_link) { create(:social_link, group: third_group, updated_at: yesterday, author: user, news_feed_link_attributes: { news_feed_id: third_group.news_feed.id }) }
      let!(:another_social_link) { create(:social_link, group: third_group, updated_at: today, author: user, news_feed_link_attributes: { news_feed_id: third_group.news_feed.id }) }

      it 'sends an email of notification to user' do
        Timecop.freeze(Date.today) do
          mailer = double('mailer')
          expect(UserGroupMailer).to receive(:notification)
            .with(user, [{
                           group: group,
                           events: [],
                           events_count: 0,
                           messages: [],
                           messages_count: 0,
                           news: [news_link],
                           news_count: 1,
                           social_links: [],
                           social_links_count: 0,
                           participating_events: [],
                           participating_events_count: 0
                         }]) { mailer }
          expect(mailer).to receive(:deliver_now)
          subject.perform({ notifications_frequency: 'daily', enterprise_id: user.enterprise_id })
        end
      end
    end
  end

  context 'with weekly frequency' do
    let!(:user) { create(:user, groups_notifications_frequency: User.groups_notifications_frequencies[:weekly], groups_notifications_date: User.groups_notifications_dates[:monday]) }

    context 'and there is no messages or news' do
      it 'does no send an email of notification to user' do
        Timecop.freeze(Date.today.next_week(:monday)) do
          expect(UserGroupMailer).to_not receive(:notification)
          subject.perform({ notifications_frequency: 'weekly', enterprise_id: user.enterprise_id })
        end
      end
    end

    context 'and there is new messages or news and notifications_date is Monday' do
      before {
        allow(Date).to receive(:today).and_return(Date.today.monday)
      }

      let(:week_ago) { (7.days + 1.second).ago }
      let(:today) { Date.today }

      let!(:user_group) { create(:user_group, user: user, group: group) }
      let!(:group_message) { create(:group_message, group: group, updated_at: week_ago, owner: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:another_group_message) { create(:group_message, group: group, updated_at: today, owner: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:group_event) { create(:initiative, owner_group: group, updated_at: week_ago, owner: user) }
      let!(:another_group_event) { create(:initiative, owner_group: group, updated_at: today, owner: user) }
      let!(:third_group_event) { create(:initiative, owner_group: second_group, updated_at: week_ago, owner: user) }
      let!(:fourth_group_event) { create(:initiative, owner_group: second_group, updated_at: today, owner: user) }
      let!(:initiative_participating_group) { create(:initiative_participating_group, initiative: third_group_event, group: group) }
      let!(:second_initiative_participating_group) { create(:initiative_participating_group, initiative: fourth_group_event, group: group) }
      let!(:news_link) { create(:news_link, group: group, updated_at: week_ago, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:another_news_link) { create(:news_link, group: group, updated_at: today, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:social_link) { create(:social_link, group: group, updated_at: week_ago, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:another_social_link) { create(:social_link, group: group, updated_at: today, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }

      it 'sends an email of notification to user' do
        mailer = double('mailer')
        expect(UserGroupMailer).to receive(:notification)
          .with(user, [{
                         group: group,
                         events: [another_group_event],
                         events_count: 1,
                         messages: [another_group_message],
                         messages_count: 1,
                         news: [another_news_link],
                         news_count: 1,
                         social_links: [another_social_link],
                         social_links_count: 1,
                         participating_events: [fourth_group_event],
                         participating_events_count: 1
                       }]) { mailer }
        expect(mailer).to receive(:deliver_now)
        subject.perform({ notifications_frequency: 'weekly', enterprise_id: user.enterprise_id })
      end

      it 'sends an email of notification to user when user is in segment and items are not in segments' do
        segment = create(:segment, groups: [group, second_group])
        create(:users_segment, user: user, segment: segment)

        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double('mailer')
          expect(UserGroupMailer).to receive(:notification)
            .with(user, [{
                           group: group,
                           events: [another_group_event],
                           events_count: 1,
                           messages: [another_group_message],
                           messages_count: 1,
                           news: [another_news_link],
                           news_count: 1,
                           social_links: [another_social_link],
                           social_links_count: 1,
                           participating_events: [fourth_group_event],
                           participating_events_count: 1
                         }]) { mailer }
          expect(mailer).to receive(:deliver_now)
          subject.perform({ notifications_frequency: 'weekly', enterprise_id: user.enterprise_id })
        end
      end

      it 'sends an email of notification to user when user is in segment and items are in segment' do
        segment = create(:segment, groups: [group, second_group])
        create(:users_segment, user: user, segment: segment)

        create(:news_link_segment, news_link: news_link, segment: segment)
        create(:social_link_segment, social_link: social_link, segment: segment)
        create(:group_messages_segment, group_message: group_message, segment: segment)

        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double('mailer')
          expect(UserGroupMailer).to receive(:notification)
            .with(user, [{
                           group: group,
                           events: [another_group_event],
                           events_count: 1,
                           messages: [another_group_message],
                           messages_count: 1,
                           news: [another_news_link],
                           news_count: 1,
                           social_links: [another_social_link],
                           social_links_count: 1,
                           participating_events: [fourth_group_event],
                           participating_events_count: 1
                         }]) { mailer }
          expect(mailer).to receive(:deliver_now)
          subject.perform({ notifications_frequency: 'weekly', enterprise_id: user.enterprise_id })
        end
      end

      it 'send an email of notification only for events to user when user is not in segment and items are in segment' do
        segment = create(:segment, groups: [group, second_group])

        create(:news_link_segment, news_link: news_link, segment: segment)
        create(:news_link_segment, news_link: another_news_link, segment: segment)
        create(:social_link_segment, social_link: social_link, segment: segment)
        create(:social_link_segment, social_link: another_social_link, segment: segment)
        create(:group_messages_segment, group_message: group_message, segment: segment)
        create(:group_messages_segment, group_message: another_group_message, segment: segment)

        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double('mailer')
          expect(UserGroupMailer).to receive(:notification)
            .with(user, [{
                           group: group,
                           events: [another_group_event],
                           events_count: 1,
                           messages: [],
                           messages_count: 0,
                           news: [],
                           news_count: 0,
                           social_links: [],
                           social_links_count: 0,
                           participating_events: [fourth_group_event],
                           participating_events_count: 1
                         }]) { mailer }
          expect(mailer).to receive(:deliver_now)
          subject.perform({ notifications_frequency: 'weekly', enterprise_id: user.enterprise_id })
        end
      end

      it 'does not send an email of notification only for events to user when user is not in segment and items are in segment' do
        segment = create(:segment, groups: [group, second_group])

        create(:news_link_segment, news_link: news_link, segment: segment)
        create(:news_link_segment, news_link: another_news_link, segment: segment)
        create(:social_link_segment, social_link: social_link, segment: segment)
        create(:social_link_segment, social_link: another_social_link, segment: segment)
        create(:group_messages_segment, group_message: group_message, segment: segment)
        create(:group_messages_segment, group_message: another_group_message, segment: segment)

        Initiative.destroy_all

        Timecop.freeze(Time.now + 30.minutes) do
          mailer = double('mailer')
          expect(UserGroupMailer).to_not receive(:notification)
          expect(mailer).to_not receive(:deliver_now)
          subject.perform({ notifications_frequency: 'weekly', enterprise_id: user.enterprise_id })
        end
      end
    end

    context 'and there is new messages or news and date is Sunday' do
      before {
        allow(Date).to receive(:today).and_return(Date.today.sunday)
      }

      let(:week_ago) { (7.days + 1.second).ago }
      let(:today) { Date.today }

      let!(:user_group) { create(:user_group, user: user, group: group) }
      let!(:group_message) { create(:group_message, group: group, updated_at: week_ago, owner: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:another_group_message) { create(:group_message, group: group, updated_at: today, owner: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:group_event) { create(:initiative, owner_group: group, updated_at: week_ago, owner: user) }
      let!(:another_group_event) { create(:initiative, owner_group: group, updated_at: today, owner: user) }
      let!(:third_group_event) { create(:initiative, owner_group: second_group, updated_at: week_ago, owner: user) }
      let!(:fourth_group_event) { create(:initiative, owner_group: second_group, updated_at: today, owner: user) }
      let!(:initiative_participating_group) { create(:initiative_participating_group, initiative: third_group_event, group: group) }
      let!(:second_initiative_participating_group) { create(:initiative_participating_group, initiative: fourth_group_event, group: group) }
      let!(:news_link) { create(:news_link, group: group, updated_at: week_ago, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:another_news_link) { create(:news_link, group: group, updated_at: today, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:social_link) { create(:social_link, group: group, updated_at: week_ago, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }
      let!(:another_social_link) { create(:social_link, group: group, updated_at: today, author: user, news_feed_link_attributes: { news_feed_id: group.news_feed.id }) }

      it 'does not send an email of notification to user because default notifications_date is Monday' do
        mailer = double('mailer')
        expect(UserGroupMailer).to_not receive(:notification)
          .with(user, [{
                         group: group,
                         events: [another_group_event],
                         events_count: 1,
                         messages: [another_group_message],
                         messages_count: 1,
                         news: [another_news_link],
                         news_count: 1,
                         social_links: [another_social_link],
                         social_links_count: 1,
                         participating_events: [fourth_group_event],
                         participating_events_count: 1
                       }]) { mailer }
        expect(mailer).to_not receive(:deliver_now)
        subject.perform({ notifications_frequency: 'weekly', enterprise_id: user.enterprise_id })
      end
    end
  end
end
