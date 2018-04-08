require 'rails_helper'

RSpec.feature 'Group Membership Management' do
	let!(:enterprise) { create(:enterprise, name: 'The Enterprise') }
	let!(:guest_user) { create(:user, enterprise_id: enterprise.id, policy_group: guest_user_policy_setup(enterprise),
	 first_name: 'Aaron', last_name: 'Patterson') }
	let!(:admin_user) { create(:user, enterprise_id: enterprise.id, first_name: 'Yehuda', last_name: 'Katz',
	 policy_group: admin_user_policy_setup(enterprise)) }
	let!(:group) { create(:group, name: 'Group ONE', enterprise: enterprise) }


	context 'when group has enable pending users' do
		pending_membership_message = '* Please wait for group administrators to process your membership request.
		Take a survey below in order to speed up approval process.'

		before do
			group.update(pending_users: 'enabled')
			login_as(guest_user, scope: :user)
		end

		scenario 'when user joins a group' do
			visit group_path(group)

			expect(page).to have_button 'Join this ERG'

			click_on 'Join this ERG'

			expect(page).to have_content 'The member was created'
			expect(page).to have_content pending_membership_message
		end

		context 'when user joins a group' do
			before do
				create(:user_group, user_id: guest_user.id, group_id: group.id, accepted_member: false)
				logout_user_in_session
				user_logs_in_with_correct_credentials(admin_user)

				visit pending_group_group_members_path(group)

				expect(page).to have_content guest_user.name
			end

			scenario 'and is accepted by admin', js: true do
				click_link 'Accept Member', href: "/groups/#{group.id}/members/#{guest_user.id}/accept_pending"

				expect(page).not_to have_content guest_user.name

				visit group_group_members_path(group)

				expect(page).to have_content 'Members (1)'
				expect(page).to have_content guest_user.first_name
			end

			scenario 'and is rejected by admin', js: true do
				page.accept_confirm(wait: 'Are you sure?') do
					click_link 'Remove From Group', "/groups/#{group.id}/members/#{guest_user.id}/remove_member"
				end

				expect(current_path).to eq group_group_members_path(group)
				expect(page).not_to have_content guest_user.name
			end
		end
	end

	context 'when pending users is disabled by group'
end