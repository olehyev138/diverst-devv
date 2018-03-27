module FeatureSpecRefactors
	def user_logs_in_with_correct_credentials(user)
		visit root_path

		fill_in 'user_email', with: user.email
		fill_in 'user_password', with: user.password
		click_on 'Log in'

		expect(current_url).to eq user_root_url
	end

	def user_logs_in_with_incorrect_credentials
		visit root_path

		fill_in 'user_email', with: 'idontexist@diverst.com'
		fill_in 'user_password', with: 'wh4t3v3r'
		click_on 'Log in'

		expect(current_url).to eq new_user_session_url
	end
end