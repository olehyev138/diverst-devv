module FeatureSpecRefactors
	def pause_test_and_browse_site_in_test_mode
		if Rails.env.test?
			puts current_url
			require 'pry-rails'; binding.pry
		end
	end

	def logout_user_in_session
		visit user_root_path

		click_link 'Log out', match: :first
	end

	def user_logs_in_with_correct_credentials(user)
		visit root_path

		fill_in 'user_email', with: user.email
		fill_in 'user_password', with: user.password
		click_on 'Log in'

		expect(current_path).to eq user_root_path
	end

	def user_logs_in_with_incorrect_credentials
		visit root_path

		fill_in 'user_email', with: 'idontexist@diverst.com'
		fill_in 'user_password', with: 'wh4t3v3r'
		click_on 'Log in'

		expect(current_path).to eq new_user_session_path
	end

	def format_date_time(date_time)
		date_time.strftime("%Y-%m-%d %H:%m")
	end

	def fill_user_invitation_form(with_custom_fields:)
		fill_in 'user[email]', with: 'derek@diverst.com'
		fill_in 'user[first_name]', with: 'Derek'
		fill_in 'user[last_name]', with: 'Owusu-Frimpong'

		if with_custom_fields
			page.all('#all-custom-fields') do
				fill_in 'BIO', with: 'I am a passionate ruby developer'
				select 'Male', from: 'Gender'
			end
		end

		click_on 'Send an invitation'
	end

	def set_custom_text_fields
		create(:field, title: 'BIO', container_id: enterprise.id,
			container_type: 'Enterprise')
	end

	def set_custom_select_fields
		create(:select_field, title: 'Gender', options_text: "Male \r\nFemale", container_id: enterprise.id,
			container_type: 'Enterprise')
	end

	def set_custom_checkbox_fields
		create(:checkbox_field, title: 'Programming Language', options_text: "Ruby\r\nElixir\r\nC++\r\nJavaScript",
			container_id: enterprise.id, container_type: 'Enterprise')
	end

	def set_custom_numeric_fields
		create(:numeric_field, title: 'Age-restrictions', min: 18, max: 98, container_id: enterprise.id,
			container_type: 'Enterprise')
	end

	def set_custom_date_fields
		create(:date_field, title: 'Date of Birth', container_id: enterprise.id, container_type: 'Enterprise')
	end

	def expect_new_text_field_form
		within('.nested-fields') do
			expect(page).to have_field '* Title', with: 'New text field'
			expect(page).to have_unchecked_field('Allow multiple lines')
			expect(page).to have_unchecked_field('Hide from users')
			expect(page).to have_unchecked_field('Allow user to edit')
			expect(page).to have_unchecked_field('Set as mandatory')
			expect(page).to have_field('Saml attribute', with: '')
		end
	end

	def expect_new_select_field_form
		within('.nested-fields') do
			expect(page).to have_field('* Title', with: 'New select field', type: 'text')
			expect(page).to have_field('Options (one per line)', type: 'textarea')
			expect(page).to have_unchecked_field('Hide from users', type: 'checkbox')
			expect(page).to have_unchecked_field('Allow user to edit', type: 'checkbox')
			expect(page).to have_unchecked_field('Set as mandatory', type: 'checkbox')
			expect(page).to have_field('Saml attribute', with: '')
		end
	end

	def expect_new_checkbox_field_form
		within('.nested-fields') do
			expect(page).to have_field('* Title', with: 'New checkbox field', type: 'text')
			expect(page).to have_field('Options (one per line)', type: 'textarea')
			expect(page).to have_unchecked_field('Use multi-select field', type: 'checkbox')
			expect(page).to have_unchecked_field('Hide from users', type: 'checkbox')
			expect(page).to have_unchecked_field('Allow user to edit', type: 'checkbox')
			expect(page).to have_unchecked_field('Set as mandatory', type: 'checkbox')
			expect(page).to have_field('Saml attribute', with: '')
		end
	end

	def expect_new_numeric_field_form
		within('.nested-fields') do
			expect(page).to have_field('* Title', with: 'New numeric field', type: 'text')
			expect(page).to have_field('Min', type: 'number')
			expect(page).to have_field('Max', type: 'number')
			expect(page).to have_unchecked_field('Show slider instead', type: 'checkbox')
			expect(page).to have_unchecked_field('Hide from users', type: 'checkbox')
			expect(page).to have_unchecked_field('Allow user to edit', type: 'checkbox')
			expect(page).to have_unchecked_field('Set as mandatory', type: 'checkbox')
			expect(page).to have_field('Saml attribute', with: '')
		end
	end

	def expect_new_date_field_form
		within('.nested-fields') do
			expect(page).to have_field('* Title', with: 'New date field', type: 'text')
			expect(page).to have_unchecked_field('Hide from users')
			expect(page).to have_unchecked_field('Allow user to edit')
			expect(page).to have_unchecked_field('Set as mandatory')
			expect(page).to have_field('Saml attribute', with: '')
		end
	end
end