require 'rails_helper'

RSpec.feature 'CustomText Management' do
	let!(:enterprise) { create(:enterprise, time_zone: "UTC", enable_rewards: true) }
	let!(:admin_user) { create(:user, enterprise: enterprise) }
	let!(:group) { create(:group, enterprise_id: enterprise.id, pending_users: 'enabled') }

	before do
		login_as(admin_user, scope: :user)
	end

	context 'Create custom text for' do
		scenario 'Erg' do
			visit edit_custom_text_path(enterprise)

			expect(page).to have_content 'Manage ERG'

			fill_in 'custom_text[erg]', with: 'Clan'

			click_on 'Update Custom text'

			expect(page).to have_content 'Manage Clan'
		end

		scenario 'Program' do
			visit group_outcomes_path(group)

			expect(page).to have_content 'Add Program'

			visit edit_custom_text_path(enterprise)

			fill_in 'custom_text[program]', with: 'Event'

			click_on 'Update Custom text'

			visit group_outcomes_path(group)

			expect(page).to have_no_content 'Add Program'
			expect(page).to have_content 'Add Event'
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

			expect(page).to have_content 'Outcome'

			visit edit_custom_text_path(enterprise)

			fill_in 'custom_text[outcome]', with: 'Program Result'

			click_on 'Update Custom text'

			visit group_outcomes_path(group)

			expect(page).to have_no_content 'Outcome'
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

			expect(page).to have_content 'Segments'

			visit edit_custom_text_path(enterprise)

			fill_in 'custom_text[segment]', with: 'Sectors'

			click_on 'Update Custom text'

			visit segments_path

			expect(page).to have_no_content 'Segments'
			expect(page).to have_content 'Sectors'
		end

		scenario 'Dci full title and abbreviation' do
			visit user_rewards_path

			expect(page).to have_content 'Diversity Culture Index (DCI)'

			visit edit_custom_text_path(enterprise)

			fill_in 'custom_text[dci_full_title]', with: 'Alpha and Beta'
			fill_in 'custom_text[dci_abbreviation]', with: 'A&B'

			click_on 'Update Custom text'

			visit user_rewards_path

			expect(page).to have_no_content 'Diversity Culture Index (DCI)'
			expect(page).to have_content 'Alpha and Beta (A&B)'
		end

		scenario 'Member preference' do
			create(:user_group, user: create(:user, enterprise: enterprise), group_id: group.id,
				accepted_member: false)

			visit pending_group_group_members_path(group)

			expect(page).to have_content 'Show Member Preference'

			visit edit_custom_text_path(enterprise)

			fill_in 'custom_text[member_preference]', with: 'Member Predisposition'

			click_on 'Update Custom text'

			visit pending_group_group_members_path(group)

			expect(page).to have_no_content 'Show Member Preference'
			expect(page).to have_content 'Show Member Predisposition'
		end

		scenario 'Parent' do
			visit edit_group_path(group)

			expect(page).to have_content 'Parent-Erg'

			visit edit_custom_text_path(enterprise)

			fill_in 'custom_text[parent]', with: 'Head'

			click_on 'Update Custom text'

			visit edit_group_path(group)

			expect(page).to have_no_content 'Parent-Erg'
			expect(page).to have_content 'Head-Erg'
		end
	end
end