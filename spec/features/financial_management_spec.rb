require 'rails_helper'

RSpec.feature 'Financial Management' do
	let!(:enterprise) { create(:enterprise) }
	let!(:admin_user) { create(:user, enterprise_id: enterprise.id, policy_group: create(:policy_group,
		enterprise_id: enterprise.id)) }
	let!(:icon) { File.new('spec/fixtures/files/trophy_image.jpg') }
	let!(:competition_category) { create(:expense_category, enterprise_id: enterprise.id, name: 'hackathon',
		icon: icon) }

	before do
		login_as(admin_user, scope: :user)
		visit expenses_path
	end

	context 'An Expense' do
		scenario 'create an expense', js: true do
			click_on 'New Item'

			expect(page).to have_content 'Create a new item'

			fill_in 'expense[name]', with: 'In-house hackathon'
			fill_in 'expense[price]', with: 20000
			select competition_category.name, from: 'expense[category_id]'

			page.find('.segmented-control__item', text: 'Expense').click

			click_on 'Create Expense'

			expect(page).to have_flash_message 'Your expense was created'
			expect(page).to have_content 'In-house hackathon'
			expect(page).to have_content '$20,000'
			expect(page).to have_icon_image 'trophy_image'
		end
	end
end