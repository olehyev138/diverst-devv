module FeatureSpecRefactors
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
end