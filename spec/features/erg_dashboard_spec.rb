require 'rails_helper'

RSpec.feature 'An ERG dashboard' do
  let(:user) { create(:user) }
  let(:group) { create(:group_with_users, users_count: 5, enterprise: user.enterprise) }

  before do
    login_as(user, scope: :user)
  end

  scenario 'shows the newest members' do
    visit group_path(group)

    expect(page).to have_content group.members.last.name
  end

  scenario 'shows the upcoming events' do
    create_list(:initiative, 5, owner_group: group, start: 2.days.from_now)
    visit group_path(group)

    expect(page).to have_content group.own_initiatives.last.name
  end

  scenario 'shows the latest news' do
    create_list(:news_link, 5, group: group)

    visit group_path(group)

    expect(page).to have_content group.news_links.last.title
  end

  scenario 'shows the latest messages' do
    create_list(:group_message, 5, group: group)

    visit group_path(group)

    expect(page).to have_content group.messages.last.subject
  end

  scenario 'allows to a non-member to opt in' do
    visit group_path(group)
    click_on 'Join this ERG'

    expect(page).to have_content 'Leave this ERG'
  end

  scenario 'allows to a member to opt out' do
    group.members << user

    visit group_path(group)
    click_on 'Leave this ERG'

    expect(group.members.ids).not_to include user.id
  end

  context 'in the members section' do
    scenario 'shows members' do
      visit group_group_members_path(group)

      expect(page).to have_content group.members.last.name
    end

    scenario 'allows users to delete members' do
      member = create(:user, enterprise: user.enterprise, first_name: "Testing", last_name: "User")
      group.members << member
      group.accept_user_to_group(member.id)

      visit group_group_members_path(group)
      expect(page).to have_content member.name
      page.find('div.flex-row__cell', text: member.name).find(:xpath, '..').find('a[data-method=delete]').click

      expect(page).not_to have_content member.name
    end
  end

  context 'in the messages section' do
    scenario 'shows the existing messages' do
      message = create(:group_message, group: group)

      visit group_group_messages_path(group)

      expect(page).to have_content message.subject
    end

    scenario 'allows users to create messages' do
      message_subject = 'I am a subject'
      message_content = 'The message content'
      create(:segment_with_users, enterprise: user.enterprise)

      visit group_group_messages_path(group)
      click_on 'Create new message'
      fill_in 'group_message_subject', with: message_subject
      fill_in 'group_message_content', with: message_content
      page.first('#group_message_segment_ids option').select_option # Select a segment
      submit_form

      expect(page).to have_content message_subject
      expect(page).to have_content message_content
    end
  end

  context 'in the events section' do
    scenario 'shows the upcoming events' do
      event = create(:event, group: group, start: 1.day.from_now, end: 1.day.from_now + 2.hours)

      visit group_events_path(group)

      expect(page).to have_content event.title
    end

    scenario 'shows the past events' do
      event = create(:event, group: group, start: 1.day.ago, end: 1.day.ago + 2.hours)

      visit group_events_path(group)

      expect(page).to have_content event.title
    end

    scenario 'allows users to create events' do
      create(:segment_with_users, enterprise: user.enterprise)
      event_title = 'Sick event!'
      event_description = 'Awesome event description'

      visit group_events_path(group)
      click_on 'Create new event'
      fill_in 'event_title', with: event_title
      fill_in 'event_description', with: event_description
      select Time.current.year + 1, from: "event_end_1i"
      fill_in 'event_location', with: 'Montreal'
      fill_in 'event_max_attendees', with: 15

      submit_form

      expect(page).to have_content event_title
    end
  end
end
