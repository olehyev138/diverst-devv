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

		scenario 'by editing sponsor details with sponsor message enabled' do
			fill_in 'enterprise[cdo_name]', with: 'Mark Zuckerberg'
			fill_in 'enterprise[cdo_title]', with: 'CEO of Facebook'
			fill_in 'enterprise[cdo_message_email]', with: 'Welcome to this Enterprise peeps:)!!'
			fill_in 'enterprise[privacy_statement]', with: 'This is the enterprise privacy statement'

			click_on 'Save sponsor info'

			visit user_root_path

			expect(page).to have_content 'Mark Zuckerberg'
			expect(page).to have_content 'CEO of Facebook'
			expect(page).to have_content 'Welcome to this Enterprise peeps:)!!'

			visit user_privacy_statement_path

			expect(page).to have_content 'This is the enterprise privacy statement'
		end

		scenario 'by editing sponsor details with sponsor message disabled', js: true do
			enterprise.update(
				cdo_name: 'Mark Zuckerberg',
				cdo_title: 'CEO of Facebook',
				cdo_message_email: 'Welcome to this Enterprise peeps:)!!'
				)
			visit user_root_path

			expect(page).to have_content 'Mark Zuckerberg'
			expect(page).to have_content 'CEO of Facebook'
			expect(page).to have_content 'Welcome to this Enterprise peeps:)!!'

			visit edit_branding_enterprise_path(enterprise)

			disable_home_sponsor_message_button.trigger('click')

			click_on 'Save sponsor info'

			visit user_root_path

			expect(page).to have_no_content 'Mark Zuckerberg'
			expect(page).to have_no_content 'CEO of Facebook'
			expect(page).to have_no_content 'Welcome to this Enterprise peeps:)!!'
		end

		scenario 'by uploading sponsor image' do
			attach_file('enterprise[sponsor_media]', 'spec/fixtures/files/sponsor_image.jpg')

			click_on 'Save sponsor info'

			visit user_root_path

			expect(page).to have_sponsor_image "sponsor_image"
		end

		scenario 'by uploading sponsor video', js: true do
			attach_file('enterprise[sponsor_media]', 'spec/fixtures/video_file/sponsor_video.mp4')

			click_on 'Save sponsor info'

			visit user_root_path

			expect(page).to have_sponsor_video "sponsor_video"
		end
	end
end