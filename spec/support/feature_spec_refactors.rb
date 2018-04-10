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

	def guest_user_policy_setup(enterprise)
		create(:policy_group,
			name: 'Guest User',
			enterprise_id: enterprise.id,
			campaigns_index: false,
			campaigns_create: false,
			campaigns_manage: false,
			polls_index: false,
			polls_create: false,
			polls_manage: false,
			group_messages_index: false,
			group_messages_create: false,
			group_messages_manage: false,
			groups_index: false,
			groups_create: false,
			groups_manage: false,
			groups_members_index: false,
			groups_members_manage: false,
			groups_budgets_index: false,
			groups_budgets_request: false,
			metrics_dashboards_index: false,
			metrics_dashboards_create: false,
			news_links_index: false,
			news_links_create: false,
			news_links_manage: false,
			enterprise_resources_index: false,
			enterprise_resources_create: false,
			enterprise_resources_manage: false,
			segments_index: false,
			segments_create: false,
			segments_manage: false,
			users_index: false,
			users_manage: false,
			global_settings_manage: false,
			initiatives_index: false,
			initiatives_create: false)
	end

	def admin_user_policy_setup(enterprise)
		create(:policy_group,
			name: 'Admin User',
			enterprise_id: enterprise.id,
			campaigns_index: true,
			campaigns_create: true,
			campaigns_manage: true,
			polls_index: true,
			polls_create: true,
			polls_manage: true,
			group_messages_index: true,
			group_messages_create: true,
			group_messages_manage: true,
			groups_index: true,
			groups_create: true,
			groups_manage: true,
			groups_members_index: true,
			groups_members_manage: true,
			groups_budgets_index: true,
			groups_budgets_request: true,
			metrics_dashboards_index: true,
			metrics_dashboards_create: true,
			news_links_index: true,
			news_links_create: true,
			news_links_manage: true,
			enterprise_resources_index: true,
			enterprise_resources_create: true,
			enterprise_resources_manage: true,
			segments_index: true,
			segments_create: true,
			segments_manage: true,
			users_index: true,
			users_manage: true,
			global_settings_manage: true,
			initiatives_index: true,
			initiatives_create: true)
	end

	def format_date_time(date_time)
    	date_time.strftime("%Y-%m-%d %H:%m")
  	end
end