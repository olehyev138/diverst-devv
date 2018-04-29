require 'rails_helper'

RSpec.feature 'Survey Management' do
	let!(:enterprise) { create(:enterprise) }
	let!(:admin_user) { create(:user, enterprise_id: enterprise.id, policy_group: create(:policy_group,
		enterprise_id: enterprise.id)) }
	let!(:group) { create(:group, enterprise_id: enterprise.id) }

	before do
		login_as(admin_user, scope: :user)
	end

	scenario 'create survey', js: true do
		visit new_poll_path

		fill_in 'poll[title]', with: 'First Group Survey'
		fill_in 'poll[description]', with: 'Everyone is welcome to fill out this particular survey'
		select group.name, from: 'Choose the ERGs you want to target'

		click_on 'Save and publish'

		expect(page).to have_content 'First Group Survey'
	end

	context 'when creating a survey' do
		before do
			visit new_poll_path

			fill_in 'poll[title]', with: 'First Group Survey'
			fill_in 'poll[description]', with: 'Everyone is welcome to fill out this particular survey'
			select group.name, from: 'Choose the ERGs you want to target'
		end

		scenario 'add custom fields', js: true do
			click_on 'Add text field'
		end
	end
end