require 'rails_helper'

RSpec.feature 'Manage Enterprise Branding' do
	let!(:enterprise) { create(:enterprise, theme: create(:theme, primary_color: '#7b77c9')) }
	let!(:admin_user) { create(:user, enterprise: enterprise) }
	let!(:group) { create(:group, enterprise_id: enterprise.id) }

	before do
		login_as(admin_user, scope: :user)
	end

	context 'Branding management' do
		before { visit edit_branding_enterprise_path(enterprise) }

		context 'Customize branding' do
			scenario 'by editing default colors', js: true do
				style = computed_style '.btn--primary', 'background'

				expect(style).to have_default_primary_color #the hex color equivalent is #7b77c9

				fill_in 'enterprise[theme][primary_color]', with: '#FFEE7F'

				click_on 'Save branding'

				style = computed_style '.btn--primary', 'background'
				expect(style).not_to eq have_default_primary_color
				expect(style).to have_custom_color("rgb(255, 238, 127)") #the hex color equivalent is #FFEE7F
			end
		end

		scenario 'restore default branding', js: true do
			fill_in 'enterprise[theme][primary_color]', with: '#FFEE7F'

			click_on 'Save branding'

			style = computed_style '.btn--primary', 'background'
			expect(style).not_to have_default_primary_color

			click_on 'Restore to default'

			style = computed_style '.btn--primary', 'background'
			expect(style).to have_default_primary_color
		end

		scenario 'upload image as custom logo' do
			expect(page).to have_default_logo

			attach_file('enterprise[theme][logo]', 'spec/fixtures/files/verizon_logo.png')

			click_on 'Save branding'

			expect(page).to have_no_default_logo
			expect(page).to have_custom_logo("verizon_logo")
		end
	end

	context 'Customize Home View' do
		scenario 'by editing home banner and message' do
			visit user_root_path
			expect(page).to have_no_banner

			visit edit_branding_enterprise_path(enterprise)

			attach_file('enterprise[banner]', 'spec/fixtures/files/verizon_logo.png')
			fill_in 'enterprise[home_message]', with: 'Welcome to Verizon! Join any group to view recent and future events'
			click_on 'Save user settings'

			visit user_root_path

			within('.enterprise-banner') do
				expect(page).to have_banner "verizon_logo"
			end
			expect(page).to have_content 'Welcome to Verizon! Join any group to view recent and future events'
		end

		scenario 'choose a timezone', js: true do
			event = create(:initiative, start: Time.now, end: Time.now + 1.days, owner_group_id: group.id,
			 owner: admin_user, pillar: create(:pillar, outcome: create(:outcome, name: 'First Outcome', group_id: group.id)))

			visit edit_branding_enterprise_path(enterprise)

			select '(GMT-06:00) Central America', from: 'enterprise[time_zone]'

			click_on 'Save timezone'

			visit group_event_path(group, event)

			expect(page).to display_timezone 'Central America'
		end
	end

	context 'Customize Program Sponsor Details' do
		before { visit edit_branding_enterprise_path(enterprise) }

		scenario 'by creating multiple enterprise sponsors', js: true do
			expect(page).to have_link 'Add an enterprise sponsor'

			click_on 'Add an enterprise sponsor'

			fill_in 'Sponsor name', with: 'Bill Gates'
			fill_in 'Sponsor title', with: 'CEO of Microsoft'
			attach_file('Upload sponsor image or video', 'spec/fixtures/files/sponsor_image.jpg')
			fill_in 'Home page sponsor message', with: 'Hi and welcome'

			click_on 'Add an enterprise sponsor'

			within all('.nested-fields')[1] do
				fill_in 'Sponsor name', with: 'Mark Zuckerberg'
				fill_in 'Sponsor title', with: 'Founder & CEO of Facebook'
				attach_file('Upload sponsor image or video', 'spec/fixtures/files/sponsor_image.jpg')
				fill_in 'Home page sponsor message', with: 'Hi and welcome'
			end

			click_on 'Add an enterprise sponsor'

			within all('.nested-fields')[2] do
				fill_in 'Sponsor name', with: 'Elizabeth Holmes'
				fill_in 'Sponsor title', with: 'Founder & CEO of Theranos'
				attach_file('Upload sponsor image or video', 'spec/fixtures/files/sponsor_image.jpg')
				fill_in 'Home page sponsor message', with: 'Hi and welcome'
			end

			click_on 'Add an enterprise sponsor'

			within all('.nested-fields')[3] do
				fill_in 'Sponsor name', with: 'Elon Musk'
				fill_in 'Sponsor title', with: 'Founder & CEO of Telsa'
				attach_file('Upload sponsor image or video', 'spec/fixtures/files/sponsor_image.jpg')
				fill_in 'Home page sponsor message', with: 'Hi and welcome'
			end

			click_on 'Save sponsor info'

			visit user_root_path

			expect(page).to have_content 'Bill Gates'
		end
	end
end