require 'rails_helper'

RSpec.feature 'News Feed Management' do
	let!(:user) { create(:user) }
	let!(:group) { create(:group, name: 'Group ONE', enterprise: user.enterprise) }

	before { login_as(user, scope: :user) }

	context 'when enterprise has pending comments enabled' do
		before { user.enterprise.update(enable_pending_comments: true) }

		context 'Group Messages' do
			scenario 'when creating group messages' do
				visit group_posts_url(group)

				expect(page).to have_link '+ Create Message'

				click_on '+ Create Message'

				expect(current_url).to eq new_group_group_message_url(group)
				expect(page).to have_content 'Create a message'

				fill_in 'group_message[subject]', with: 'First Group Message'
				fill_in 'group_message[content]', with: 'This is the first group message :)'

				click_button 'Create Group message'

				group_message = GroupMessage.find_by(subject: 'First Group Message')
				expect(page).to have_content group_message.subject
				expect(page).to have_content "by #{group_message.owner.name_with_status}"
				expect(page).to have_link 'Comments(0)'
			end

			scenario 'when updating group message' do
				group_message = create(:group_message, subject: 'First Group Message',
					content: 'This is the first group message :)', group_id: group.id, owner_id: user.id)

				visit group_posts_url(group)

				expect(page).to have_content group_message.subject

				click_on 'Edit'

				expect(current_url).to eq edit_group_group_message_url(group, group_message)

				fill_in 'group_message[subject]', with: 'Updated Group Message!!!'

				click_on 'Update Group message'

				expect(current_url).to eq group_posts_url(group)
				expect(page).to_not have_content 'First Group Message'
				expect(page).to have_content 'Updated Group Message!!!'
			end
		end
	end

	context 'when enteprise has pending comments disabled'
end