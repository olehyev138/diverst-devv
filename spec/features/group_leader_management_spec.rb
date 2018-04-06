require 'rails_helper'

RSpec.feature 'Group Leader Management' do
	let!(:user) { create(:user, first_name: 'Aaron', last_name: 'Patterson') }
	let!(:group) { create(:group, name: 'Group ONE', enterprise: user.enterprise) }
	let!(:user_group) { create(:user_group, user_id: user.id, group_id: group.id) }

	before { login_as(user, scope: :user) }

	context 'Manage Group Leaders' do
		before do
			visit group_leaders_path(group)

			within('.content__header h1') do
				expect(page).to have_content 'Group Leaders'
			end
			expect(page).to have_link 'Manage leaders'

			click_on 'Manage leaders'

			within('.content__header h1') do
				expect(page).to have_content 'Add Leaders to Group ONE'
			end
			expect(page).to have_link 'Add a leader'
		end

		scenario 'add a group leader', js: true do
			click_on 'Add a leader'

			select user.name, from: page.find('.custom-user-select select')[:id]
			fill_in page.find('.custom-position-field')[:id], with: 'Chief Software Architect'

			click_on 'Save Leaders'

			expect(current_path).to eq group_leaders_path(group)
			expect(page).to have_content 'Leaders were updated'
			within('.content__header h1') do
				expect(page).to have_content 'Group Leaders'
			end
			expect(page).to have_link 'Aaron Patterson'
			expect(page).to have_content 'Chief Software Architect'
		end
	end
end