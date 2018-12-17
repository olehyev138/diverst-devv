require 'rails_helper'

RSpec.feature 'DCI Management' do
	let!(:enterprise) { create(:enterprise, enable_rewards: true )}
	let!(:admin_user) { create(:user, enterprise: enterprise) }

	before do
		login_as(admin_user, scope: :user)
	end

	context 'set points for' do
		scenario 'achievements' do
			[['Attend event', 25, "attend_event"], ["News comment", 10, "news_comment"]].each do |label, points, key|
				create(:reward_action, label: label, points: points, key: key, enterprise_id: enterprise.id)
			end

			visit rewards_path

			fill_in 'Attend event', with: 30
			fill_in 'News comment', with: 15

			click_on 'Save actions'

			expect(page).to have_field('Attend event', with: 30)
			expect(page).to have_field('News comment', with: 15)
		end

		scenario 'Prizes', js: true do
			visit rewards_path

			click_on 'New prize'

			expect(page).to have_current_path new_reward_path

			fill_in 'reward[label]', with: 'Ultimate Prize'
			fill_in 'reward[points]', with: 1000
			select admin_user.name, from: 'reward[responsible_id]'
			attach_file('reward[picture]', 'spec/fixtures/files/trophy_image.jpg')

			click_on 'Save prize'

			expect(page).to have_current_path rewards_path
			expect(page).to have_content 'Ultimate Prize'
			expect(page).to have_content '1000'
			expect(page).to have_css('a[href*="trophy_image.jpg"]')
		end
	end

	context 'Edit or Delete' do
		let!(:image) { File.new('spec/fixtures/files/gold_star.jpg') }
		let!(:picture) { File.new('spec/fixtures/files/trophy_image.jpg') }
		let!(:prize) { create(:reward, enterprise_id: enterprise.id, points: 1000, label: 'Ultimate Prize', picture: picture,
			description: 'This is indeed the ultimate prize', responsible_id: admin_user.id) }

		before { visit rewards_path }

		scenario 'Edit Prize', js: true do
			click_link 'Edit', href: edit_reward_path(prize)

			expect(page).to have_current_path edit_reward_path(prize)
			expect(page).to have_field('reward[label]', with: 'Ultimate Prize')
			expect(page).to have_field('reward[points]', with: 1000)
			expect(page).to have_select('reward[responsible_id]')
			expect(page).to have_css('a[href*="trophy_image.jpg"]')

			fill_in 'reward[points]', with: 1500

			click_on 'Save prize'

			expect(page).to have_content '1500'
			expect(page).to have_no_content '1000'
		end

		scenario 'Delete Prize', js: true do
			page.accept_confirm(wait: "Are you sure?") do
				click_link 'Delete', href: reward_path(prize)
			end
			expect(page).to have_no_content 'Ultimate Prize'
		end
	end
end