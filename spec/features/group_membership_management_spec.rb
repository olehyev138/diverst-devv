require 'rails_helper'

RSpec.feature 'Group Membership Management' do
	let!(:enterprise) { create(:enterprise, name: 'The Enterprise') }
	let!(:guest_user) { create(:user, enterprise: enterprise, policy_group: create(:guest_user, enterprise: enterprise),
	 first_name: 'Aaron', last_name: 'Patterson') }
	let!(:admin_user) { create(:user, enterprise: enterprise, first_name: 'Yehuda', last_name: 'Katz',
	 policy_group: create(:policy_group, name: 'Admin User', enterprise: enterprise)) }
	let!(:group) { create(:group, name: 'Group ONE', enterprise: enterprise) }


	context 'when group has enable pending users' do
		pending_membership_message = '* Please wait for group administrators to process your membership request.
		Take a survey below in order to speed up approval process.'
		let!(:sub_group) { create(:group, enterprise: enterprise, name: "Sub Group ONE", parent_id: group.id) }

		before do
			group.update(pending_users: 'enabled')
			login_as(guest_user, scope: :user)
		end

		context 'when a user joins a parent group with children' do
			scenario 'and is not a member of any child group', js: true do
				visit group_path(group)

                click_button "Join this #{c_t(:parent)}"

				within('.modal-content') do
					expect(page).to have_content "Thanks for joining the #{c_t(:parent)}! Do you also want to join a #{c_t(:sub_erg)}?"
					click_link "YES"
				end

				expect(page).to have_content sub_group.name
				expect(page).to have_link 'Join'

				click_link 'Join', href: join_sub_group_group_group_member_path(sub_group, guest_user)
				click_on 'DONE'

				expect(sub_group.members).to include guest_user
			end

			scenario 'and is a member of all child groups', js: true do
				create(:user_group, user_id: guest_user.id, group_id: sub_group.id, accepted_member: false)
				visit group_path(group)

				click_button "Join this #{c_t(:parent)}"

				within('.modal-content') do
					expect(page).to have_content "Thanks for joining the #{c_t(:parent)}!"
					expect(page).to have_content "OK"
					click_link "OK"
				end

				expect(page).to have_content pending_membership_message
			end
		end

		scenario 'when a user joins a sub group, prompt option to join parent group', js: true do
			visit group_path(sub_group)

			click_button "Join this #{c_t(:sub_erg)}"

			within(".modal-title") do
				expect(page).to have_content "Thanks for joining #{sub_group.name}! Do you also want to join the #{c_t(:parent)}?"
			end

			click_button "YES"

			expect(group.members).to include guest_user
			expect(sub_group.members).to include guest_user
		end

		context 'when a user' do
			let!(:parent_group) { create(:group, name: 'Group ONE', enterprise: enterprise, parent_id: nil) }

			scenario 'joins a standard group(group with no parent or child)' do
				visit group_path(parent_group)

				click_button "Join this #{c_t(:erg)}"

				expect(page).not_to have_button "Leave this #{c_t(:erg)}"
			end
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
				click_link 'Accept Member', href: accept_pending_group_group_member_path(group, guest_user)

				expect(page).to have_no_content guest_user.name

				visit group_group_members_path(group)

				expect(page).to have_content 'Members (1)'
				expect(page).to have_content guest_user.first_name
			end

			scenario 'and is rejected by admin', js: true do
				page.accept_confirm(wait: 'Are you sure?') do
					click_link 'Remove From Group', href: remove_member_group_group_member_path(group, guest_user)
				end

				expect(current_path).to eq group_group_members_path(group)
				expect(page).to have_no_content guest_user.name
			end
		end

		context 'when admin user filters members by' do
			let!(:inactive_user) { create(:user, enterprise_id: enterprise.id, first_name: "Xavier", last_name: "Nora", active: false,
			 policy_group: create(:guest_user, enterprise: enterprise)) }
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
					expect(page).to have_no_content inactive_user.name
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

			context 'time of membership based on when' do
				let!(:time_of_invitation) { Time.now - 5.days }
				before do
					guest_user.update(invitation_created_at: time_of_invitation)
					create(:user_group, user_id: guest_user.id, group_id: group.id)
					logout_user_in_session
					user_logs_in_with_correct_credentials(admin_user)
					visit group_group_members_path(group)
				end

				scenario 'users joined group from', js: true do
					fill_in 'q[user_groups_created_at_gteq]', with: format_date_time(time_of_invitation)

					click_on 'Filter'

					expect(page).to have_content guest_user.name
				end
			end
		end
	end

	context 'when pending users is disabled by group' do
		pending_membership_message = '* Please wait for group administrators to process your membership request.
		Take a survey below in order to speed up approval process.'
		let!(:sub_group) { create(:group, enterprise: enterprise, name: "Sub Group ONE", parent_id: group.id) }

		before do
			group.update(pending_users: 'disabled')
			login_as(guest_user, scope: :user)
		end

		scenario 'when a user joins a parent group with children', js: true do
			visit group_path(group)

			click_button "Join this #{c_t(:parent)}"

			within('.modal-content') do
				expect(page).to have_content "Thanks for joining the #{c_t(:parent)}! Do you also want to join a #{c_t(:sub_erg)}?"
			    click_link "YES"
			end


			expect(page).to have_content sub_group.name
			expect(page).to have_link 'Join'

			click_link 'Join', href: join_sub_group_group_group_member_path(sub_group, guest_user)
			click_on 'DONE'

			expect(sub_group.members).to include guest_user
		end

		scenario 'when a user joins a parent group with child groups and is a member of all child groups', js: true do
			create(:user_group, user_id: guest_user.id, group_id: sub_group.id, accepted_member: true)
			visit group_path(group)

			click_button "Join this #{c_t(:parent)}"

			within('.modal-content') do
				expect(page).to have_content "Thanks for joining the #{c_t(:parent)}!"
				expect(page).to have_content "OK"
				click_link "OK"
			end

			expect(page).to have_link "Leave this #{c_t(:parent)}"
		end

		scenario 'when a user joins a sub group, prompt option to join parent group', js: true do
			visit group_path(sub_group)

			click_button "Join this #{c_t(:sub_erg)}"

			within('.modal-title') do
				expect(page).to have_content "Thanks for joining #{sub_group.name}! Do you also want to join the #{c_t(:parent)}?"
			end

			click_button "YES"

			expect(group.members).to include guest_user
		end

		context 'when a user' do
			let!(:parent_group) { create(:group, name: 'Parent Group', enterprise: enterprise, parent_id: nil) }

			scenario 'joins a standard group(group with no parent or child)' do
				visit group_path(parent_group)

				click_button "Join this #{c_t(:erg)}"

				expect(page).not_to have_button "Leave this #{c_t(:erg)}"
			end
		end

		context 'when a user leaves' do
			let!(:sub_group) { create(:group, enterprise: enterprise, name: "Sub Group ONE", parent_id: group.id) }
			let!(:group_membership)	{ create(:user_group, user_id: guest_user.id, group_id: group.id, accepted_member: true) }
			let!(:sub_group_membership)	{ create(:user_group, user_id: guest_user.id, group_id: sub_group.id, accepted_member: true) }

			scenario 'a parent group', js: true do
				visit group_path(group)

				click_link "Leave this #{c_t(:parent)}"

				expect(page).to have_button "Join this #{c_t(:parent)}"
				expect(group.members).not_to include guest_user
				expect(sub_group.members).to include guest_user
			end

			scenario 'a sub group', js: true do
				visit group_path(sub_group)

				click_link "Leave this #{c_t(:sub_erg)}"

				expect(group.members).to include guest_user
				expect(sub_group.members).not_to include guest_user
			end
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
					click_link 'Remove From Group', href: remove_member_group_group_member_path(group, guest_user)
				end

				expect(page).to have_no_content guest_user.name
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