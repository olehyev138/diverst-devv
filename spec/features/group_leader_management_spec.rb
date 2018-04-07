require 'rails_helper'

RSpec.feature 'Group Leader Management' do
	let!(:user) { create(:user, first_name: 'Aaron', last_name: 'Patterson') }
	let!(:other_user) { create(:user, first_name: 'Yehuda', last_name: 'Katz') }
	let!(:group) { create(:group, name: 'Group ONE', enterprise: user.enterprise) }

	before do 
		login_as(user, scope: :user) 
		[user, other_user].each do |user|
	    	create(:user_group, user_id: user.id, group_id: group.id)
		end
	end

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

		scenario 'add multiple group leaders and display them on home page', js: true do
			click_on 'Add a leader'

			select user.name, from: page.find('.custom-user-select select')[:id]
			fill_in page.find('.custom-position-field')[:id], with: 'Chief Software Architect'
			page.find('.group-contact-field').click

			click_on 'Add a leader'

			within all('.nested-fields')[1] do
				select other_user.name, from: page.find('.custom-user-select select')[:id]
				fill_in page.find('.custom-position-field')[:id], with: 'Senior Software Engineer'
			end

			click_on 'Save Leaders'

			expect(page).to have_content 'Leaders were updated'

			visit group_path(group)

			expect(page).to have_content user.name
			expect(page).to have_content 'Chief Software Architect'
			expect(page).to have_content other_user.name
			expect(page).to have_content 'Senior Software Engineer'
		end

		scenario 'set email of displayed group leader as group contact', js: true do
			click_on 'Add a leader'

			select user.name, from: page.find('.custom-user-select select')[:id]
			fill_in page.find('.custom-position-field')[:id], with: 'Chief Software Architect'
			page.find('.group-contact-field').click

			click_on 'Save Leaders'

			visit group_path(group)

			expect(current_path).to eq group_path(group)
			expect(page).to have_content 'Aaron Patterson'
			expect(page).to have_content 'Chief Software Architect'
			expect(page).to have_button 'Contact Group Leader'
		end

		scenario 'set any other group leader(who is not displayed) as group contact', js: true do
			click_on 'Add a leader'

			select other_user.name, from: page.find('.custom-user-select select')[:id]
			fill_in page.find('.custom-position-field')[:id], with: 'Chief Software Architect'
			page.find('.show-leader-field').click
			page.find('.group-contact-field').click

			click_on 'Save Leaders'

			visit group_path(group)

			expect(current_path).to eq group_path(group)
			expect(page).not_to have_content other_user.name
			expect(page).to have_button 'Contact Group Leader'
		end
	end
end