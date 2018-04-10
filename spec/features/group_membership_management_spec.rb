require 'rails_helper'

RSpec.feature 'Group Membership Management' do
	let!(:enterprise) { create(:enterprise, name: 'The Enterprise') }
	let!(:guest_user) { create(:user, enterprise_id: enterprise.id, policy_group: guest_user_policy_setup(enterprise),
	 first_name: 'Aaron', last_name: 'Patterson') }
	let!(:admin_user) { create(:user, enterprise_id: enterprise.id, first_name: 'Yehuda', last_name: 'Katz',
	 policy_group: admin_user_policy_setup(enterprise)) }
	let!(:group) { create(:group, name: 'Group ONE', enterprise: enterprise) }


	context 'when group has enable pending users' do
		pending_membership_message = '* Please wait for group administrators to process your membership request.
		Take a survey below in order to speed up approval process.'

		before do
			group.update(pending_users: 'enabled')
			login_as(guest_user, scope: :user)
		end

		scenario 'when a user joins a group' do
			visit group_path(group)

			expect(page).to have_button 'Join this ERG'

			click_on 'Join this ERG'

			expect(page).to have_content 'The member was created'
			expect(page).to have_content pending_membership_message
		end

		context 'when user joins a group' do
			before do
				create(:user_group, user_id: guest_user.id, group_id: group.id, accepted_member: false)
				logout_user_in_session
				user_logs_in_with_correct_credentials(admin_user)

				visit pending_group_group_members_path(group)

				expect(page).to have_content guest_user.name
			end

			scenario 'and is accepted by admin', js: true do
				click_link 'Accept Member', href: "/groups/#{group.id}/members/#{guest_user.id}/accept_pending"

				expect(page).not_to have_content guest_user.name

				visit group_group_members_path(group)

				expect(page).to have_content 'Members (1)'
				expect(page).to have_content guest_user.first_name
			end

			scenario 'and is rejected by admin', js: true do
				page.accept_confirm(wait: 'Are you sure?') do
					click_link 'Remove From Group', href: "/groups/#{group.id}/members/#{guest_user.id}/remove_member"
				end

				expect(current_path).to eq group_group_members_path(group)
				expect(page).not_to have_content guest_user.name
			end
		end

		context 'when admin user filters members by' do
			let!(:inactive_user) { create(:user, enterprise_id: enterprise.id, first_name: "Xavier", last_name: "Nora", active: false,
			 policy_group: guest_user_policy_setup(enterprise)) }
			let!(:ruby_core_segment) { create(:segment, enterprise_id: enterprise.id, name: 'Ruby Core Segment',
				active_users_filter: 'only_inactive') }

			before do
				create(:user_group, user_id: inactive_user.id, group_id: group.id, accepted_member: true)
				create(:users_segment, user_id: inactive_user.id, segment_id: ruby_core_segment.id)
			end

			context 'segment' do
				before do
					logout_user_in_session
					user_logs_in_with_correct_credentials(admin_user)
					visit group_group_members_path(group)
				end

				scenario 'inactive users only', js: true do
					select 'Ruby Core Segment', from: 'q[users_segments_segment_id_in][]'

					click_on 'Filter'

					expect(page).to have_content 'Members (0)'
					expect(page).not_to have_content inactive_user.name
				end

				scenario 'active users only', js: true do
					ruby_core_segment.update(active_users_filter: 'only_active')
					[guest_user, admin_user].each do |user|
						create(:user_group, user_id: user.id, group_id: group.id)
						create(:users_segment, user_id: user.id, segment_id: ruby_core_segment.id)
					end

					select 'Ruby Core Segment', from: 'q[users_segments_segment_id_in][]'

					click_on 'Filter'

					expect(page).to have_content 'Members (2)'
					expect(page).to have_content guest_user.name
					expect(page).to have_content admin_user.name
				end
			end
		end
	end

	context 'when pending users is disabled by group' do
		pending_membership_message = '* Please wait for group administrators to process your membership request.
		Take a survey below in order to speed up approval process.'

		before do
			group.update(pending_users: 'disabled')
			login_as(guest_user, scope: :user)
		end

		scenario 'when a user joins a group' do
			visit group_path(group)

			click_button 'Join this ERG'

			expect(page).to have_content 'The member was created'
			expect(page).not_to have_content pending_membership_message
		end

		context 'user joins a group' do
			before do
				create(:user_group, user_id: guest_user.id, group_id: group.id, accepted_member: false)
				logout_user_in_session
				user_logs_in_with_correct_credentials(admin_user)
			end

			scenario 'and admin removes user from group', js: true do
				visit group_group_members_path(group)

				expect(page).to have_content guest_user.name

				page.accept_confirm(with: 'Are you sure?') do
					click_link 'Remove From Group', href: "/groups/#{group.id}/members/#{guest_user.id}/remove_member"
				end

				expect(page).not_to have_content guest_user.name
			end
	    end

	    context 'admin adds a user to a group' do
	    	before do
	    		logout_user_in_session
	    		user_logs_in_with_correct_credentials(admin_user)
	    	end

	    	scenario 'successfully', js: true do
	    		visit group_group_members_path(group)

	    		click_on '+ Add members'
	    		sleep 1

	    		expect(current_path).to eq new_group_group_member_path(group)
	    		expect(page).to have_content "Add Members to #{group.name}"

	    		select guest_user.name, from: 'group[member_ids][]'

	    		click_on 'Update Group'

	    		expect(current_path).to eq group_group_members_path(group)
	    		expect(page).to have_content 'Members (1)'
	    		expect(page).to have_content guest_user.name
	    	end
	    end
	end
end