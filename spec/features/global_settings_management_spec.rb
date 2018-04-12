require 'rails_helper'

RSpec.feature 'Global Settings Management' do
	let!(:enterprise) { create(:enterprise) }
	let!(:admin_user) { create(:user, enterprise_id: enterprise.id, policy_group: create(:policy_group, enterprise: enterprise)) }
	let!(:guest_user) { create(:user, enterprise_id: enterprise.id, policy_group: create(:guest_user, enterprise: enterprise)) }
	let!(:group) { create(:group, name: 'Group ONE', enterprise: enterprise) }

	before do
		login_as(admin_user, scope: :user)
		visit users_path
	end

	context 'permissions group settings' do
	end

	context 'manage users' do
		scenario 'add a user', js: true do
			expect(page).to have_content 'Users'

			click_on 'Add a user'

			expect(page).to have_content 'Add a user'

			fill_in 'user[email]', with: 'derek@diverst.com'
			fill_in 'user[first_name]', with: 'Derek'
			fill_in 'user[last_name]', with: 'Owusu-Frimpong'

			click_on 'Send an invitation'

			expect(current_path).to eq users_path
			expect(page).to have_content 'Derek'
			expect(page).to have_content 'Owusu-Frimpong'
			expect(page).to have_content 'derek@diverst.com'
		end
	end
end