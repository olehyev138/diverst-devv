require 'rails_helper'

RSpec.feature 'Group Membership Management' do
	let!(:enterprise) { create(:enterprise, name: 'The Enterprise') }
	let!(:non_admin_policy) { create(:policy_group, enterprise_id: enterprise.id, name: 'non admins',
		admin_pages_view: false) }
	let!(:admin_policy) { create(:policy_group, enterprise_id: enterprise.id, name: 'admins', admin_pages_view: true) }
	let!(:guest_user) { create(:user, enterprise_id: enterprise.id, policy_group_id: non_admin_policy.id,
	 first_name: 'Aaron', last_name: 'Patterson') }
	let!(:user) { create(:user, enterprise_id: enterprise.id, first_name: 'Yehuda', last_name: 'Katz') }
	let!(:group) { create(:group, name: 'Group ONE', enterprise: enterprise) }

	before do
		login_as(guest_user, scope: :user)
	end

	context 'when group has enable pending users' do
		pending_membership_message = '* Please wait for group administrators to process your membership request.
		Take a survey below in order to speed up approval process.'

		before do
			group.update(pending_users: 'enabled')
		end

		scenario 'when user joins an group' do
			visit group_path(group)

			expect(page).to have_button 'Join this ERG'

			click_on 'Join this ERG'

			expect(page).to have_content 'The member was created'
			expect(page).to have_content pending_membership_message
		end
	end
end