require 'rails_helper'

RSpec.feature 'DCI Management' do
	let!(:enterprise) { create(:enterprise, enable_rewards: true )}
	let!(:admin_user) { create(:user, enterprise_id: enterprise.id, policy_group: create(:policy_group,
		enterprise_id: enterprise.id)) }

	before do
		login_as(admin_user, scope: :user)
	end

	context 'set points for points for' do
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

		scenario 'Badges' do
			visit rewards_path

			click_on 'New Badge'

			expect(current_path).to eq new_badge_path

			fill_in 'badge[label]', with: 'gold star'
			fill_in 'badge[points]', with: 100
			attach_file('badge[image]', 'spec/fixtures/files/gold_star.jpg')

			click_on 'Save Badge'

			expect(current_path).to eq rewards_path
			expect(page).to have_content 'gold star'
			expect(page).to have_content '100'
			expect(page).to have_css('a[href*="gold_star.jpg"]')
		end
	end
end