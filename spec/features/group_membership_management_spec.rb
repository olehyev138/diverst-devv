require 'rails_helper'

RSpec.feature 'Group Membership Management' do
	let!(:enterprise) { create(:enterprise, name: 'The Enterprise') }
	let!(:guest_user) { create(:user, enterprise_id: enterprise.id, policy_group: guest_user_policy_setup(enterprise),
	 first_name: 'Aaron', last_name: 'Patterson') }
	let!(:user) { create(:user, enterprise_id: enterprise.id, first_name: 'Yehuda', last_name: 'Katz',
	 policy_group: admin_user_policy_setup(enterprise)) }
	let!(:group) { create(:group, name: 'Group ONE', enterprise: enterprise) }

	before { create(:user_group, user_id: user.id, group_id: group.id) }


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
	end

	context 'when pending users is disabled by group'
end