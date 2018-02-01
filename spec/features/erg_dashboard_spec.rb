require 'rails_helper'

RSpec.feature 'An ERG dashboard' do
  let(:user) { create(:user) }
  let(:group) { create(:group_with_users, :with_outcomes, users_count: 5, enterprise: user.enterprise) }

  before do
    login_as(user, scope: :user)
  end

  scenario 'shows the newest members', skip: "Fails because it is removed from ERG dashboard view" do
    visit group_path(group)

    expect(page).to have_content group.members.last.name
  end

  scenario 'shows the upcoming events' do
    initiative = create :initiative, owner_group: group, start: 2.days.from_now
    group.outcomes.first.pillars.first.initiatives << initiative
    group.members << user

    visit group_path(group)

    expect(page).to have_content group.initiatives.last.name
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

  scenario 'allows to a member to opt out', js: true do
    group.members << user

    visit group_path(group)
    click_on 'Leave this ERG'

    expect(group.members.ids).not_to include user.id
  end

  context 'in the members section', js: true do
    scenario 'shows members' do
      visit group_group_members_path(group)

      expect(page).to have_content group.members.last.name
    end

    scenario 'allows users to delete members', js: true do
      member = create(:user, enterprise: user.enterprise, first_name: "Testing", last_name: "User")
      group.members << member
      group.accept_user_to_group(member.id)

      visit group_group_members_path(group)
      expect(page).to have_content member.name
      page.find('.data-table td', text: member.name).find(:xpath, '..').find('a[data-method=delete]').click

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
    scenario 'does not show the upcoming events if user is a guest' do
      group.members.delete(user)
      initiative = create(:initiative, owner_group: group, start: 1.day.from_now, end: 1.day.from_now + 2.hours)
      
      visit group_events_path(group)

      expect(page).to_not have_content initiative.name
    end
    
    scenario 'shows the upcoming events' do
      initiative = create(:initiative, owner_group: group, start: 1.day.from_now, end: 1.day.from_now + 2.hours)
      create(:user_group, group: group, user: user, accepted_member: true)
      
      visit group_events_path(group)

      expect(page).to have_content initiative.name
    end

    scenario 'show the past events for guest(non-erg members)' do
      past_initiative = create(:initiative, owner_group: group, start: 1.day.ago, end: 1.day.ago + 2.hours)

      visit group_events_path(group)

      expect(page).to have_content past_initiative.name
    end
    
    scenario 'shows the past events for erg members' do
      past_initiative = create(:initiative, owner_group: group, start: 1.day.ago, end: 1.day.ago + 2.hours)
      create(:user_group, group: group, user: user, accepted_member: true)
      
      visit group_events_path(group)

      expect(page).to have_content past_initiative.name
    end
  end
end
