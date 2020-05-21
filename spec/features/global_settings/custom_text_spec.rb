require 'rails_helper'

RSpec.feature 'CustomText Management' do
  let!(:enterprise) { create(:enterprise, time_zone: 'UTC', enable_rewards: true) }
  let!(:admin_user) { create(:user, enterprise: enterprise) }
  let!(:group) { create(:group, enterprise_id: enterprise.id, pending_users: 'enabled') }

  before do
    login_as(admin_user, scope: :user)
  end

  context 'Create custom text for' do
    scenario 'Erg' do
      visit edit_custom_text_path(enterprise)

      expect(page).to have_content 'Group'

      fill_in 'custom_text[erg]', with: 'Clan'

      click_on 'Update Custom text'

      expect(page).to have_content 'Manage Clan'
    end

    scenario 'Program' do
      visit group_outcomes_path(group)

      expect(page).to have_content 'Goal'

      visit edit_custom_text_path(enterprise)

      fill_in 'custom_text[program]', with: 'Event'

      click_on 'Update Custom text'

      visit group_outcomes_path(group)

      expect(page).to have_no_content 'Goal'
      expect(page).to have_content 'Event'
    end

    scenario 'Structure' do
      visit group_outcomes_path(group)

      expect(page).to have_content 'Structure'

      visit edit_custom_text_path(enterprise)

      fill_in 'custom_text[structure]', with: 'Leadership'

      click_on 'Update Custom text'

      visit group_outcomes_path(group)

      expect(page).to have_no_content 'Structure'
      expect(page).to have_content 'Leadership'
    end

    scenario 'Outcome' do
      visit group_outcomes_path(group)

      expect(page).to have_content 'Focus Areas'

      visit edit_custom_text_path(enterprise)

      fill_in 'custom_text[outcome]', with: 'Program Result'

      click_on 'Update Custom text'

      visit group_outcomes_path(group)

      expect(page).to have_no_content 'Focus Areas'
      expect(page).to have_content 'Program Result'
    end

    scenario 'Badge' do
      visit rewards_path

      expect(page).to have_content 'Badge'

      visit edit_custom_text_path(enterprise)

      fill_in 'custom_text[badge]', with: 'Medal'

      click_on 'Update Custom text'

      visit rewards_path

      expect(page).to have_no_content 'Badge'
      expect(page).to have_content 'Medal'
    end

    scenario 'Segment' do
      visit segments_path

      expect(page).to have_content 'Segment'

      visit edit_custom_text_path(enterprise)

      fill_in 'custom_text[segment]', with: 'Sectors'

      click_on 'Update Custom text'

      visit segments_path

      expect(page).to have_no_content 'Segment'
      expect(page).to have_content 'Sectors'
    end

    scenario 'Dci full title and abbreviation' do
      visit user_rewards_path

      expect(page).to have_content 'Engagement'

      visit edit_custom_text_path(enterprise)

      fill_in 'custom_text[dci_full_title]', with: 'Alpha and Beta'
      fill_in 'custom_text[dci_abbreviation]', with: 'A&B'

      click_on 'Update Custom text'

      visit user_rewards_path

      expect(page).to have_no_content 'Engagement'
      expect(page).to have_content 'Alpha and Beta (A&B)'
    end

    scenario 'Member preference' do
      create(:user_group, user: create(:user, enterprise: enterprise), group_id: group.id,
                          accepted_member: false)

      visit pending_group_group_members_path(group)

      expect(page).to have_content 'Member Survey'

      visit edit_custom_text_path(enterprise)

      fill_in 'custom_text[member_preference]', with: 'Member Predisposition'

      click_on 'Update Custom text'

      visit pending_group_group_members_path(group)

      expect(page).to have_no_content 'Member Survey'
      expect(page).to have_content 'Show Member Predisposition'
    end

    scenario 'Parent' do
      visit edit_group_path(group)

      expect(page).to have_content 'Parent-Group'

      visit edit_custom_text_path(enterprise)

      fill_in 'custom_text[parent]', with: 'Head'

      click_on 'Update Custom text'

      visit edit_group_path(group)

      expect(page).to have_no_content 'Parent'
      expect(page).to have_content 'Head'
    end

    scenario 'Sub-Group' do
      visit edit_group_path(group)

      expect(page).to have_content 'Sub-Groups'

      visit edit_custom_text_path(enterprise)

      fill_in 'custom_text[sub_erg]', with: 'Sub erg'

      click_on 'Update Custom text'

      visit edit_group_path(group)

      expect(page).to have_content 'Sub-Groups'
      expect(page).to have_no_content 'Sub erg'
    end
  end
end
