require 'rails_helper'

RSpec.feature 'An ERG dashboard' do
  let(:user) { create(:user) }
  let(:group) { create(:group_with_users, users_count: 5, enterprise: user.enterprise) }

  before do
    login_as(user, scope: :user, run_callbacks: false)
  end

  scenario 'shows the upcoming events' do
    group.upcoming_events_visibility = 'public'
    group.save!

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

  context 'in sub-erg section' do
    let!(:category_type) { create(:group_category_type, name: 'Color Code') }
    let!(:red_label) { create(:group_category, name: 'Red', group_category_type_id: category_type.id) }

    scenario 'show categorized sub-ergs', js: true do
      group.update(group_category_type_id: category_type.id)
      red_sub_groups = create_list(:group, 2, parent_id: group.id, group_category_type_id: category_type.id,
                                              group_category_id: red_label.id, enterprise_id: user.enterprise.id)

      visit group_path(group)
      expect(page).to have_content red_label.name

      page.find('.nested_show').click
      expect(page).to have_content red_sub_groups.last.name
    end

    scenario 'show uncategorized sub-ergs as normal list' do
      sub_group = create(:group, parent_id: group.id, enterprise: user.enterprise)

      visit group_path(group)

      expect(page).not_to have_content 'Red'
      expect(page).to have_content sub_group.name
    end

    scenario 'list only 5 sub-ergs and drop down for more for uncategorized sub-ergs', skip: true, js: true do
      sub_groups = create_list(:group, 7, parent_id: group.id)

      visit group_path(group)

      expect(page).to have_content "View #{group.children.count - 5} More"
      expect(page).to have_no_content sub_groups.last.name

      page.find('.sub_ergs').click
      expect(page).to have_content sub_groups.last.name
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
      page.first('.select2-field-segments option').select_option # Select a segment
      submit_form

      expect(page).to have_content message_subject
      expect(page).to have_content message_content
    end
  end

  context 'in the events section' do
    scenario 'shows the upcoming events if user is a guest' do
      initiative = create(:initiative, owner_group: group, start: 1.day.from_now, end: 1.day.from_now + 2.hours)

      visit group_events_path(group)

      expect(page).to have_content initiative.name
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
