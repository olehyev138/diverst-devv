require 'rails_helper'

RSpec.feature 'News Feed Management' do
	let!(:user) { create(:user) }
	let!(:group) { create(:group, name: 'Group ONE', enterprise: user.enterprise) }

	before { login_as(user, scope: :user) }

	context 'when enterprise has pending comments enabled' do
		before { user.enterprise.update(enable_pending_comments: true) }

		context 'Group Messages' do
			let!(:existing_group_message) { create(:group_message, subject: 'An Old Group Message', group_id: group.id,
				 owner_id: user.id) }

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
				visit group_posts_url(group)

				expect(page).to have_content existing_group_message.subject

				click_on 'Edit'

				expect(current_url).to eq edit_group_group_message_url(group, existing_group_message)

				fill_in 'group_message[subject]', with: 'Updated Group Message!!!'

				click_on 'Update Group message'

				expect(current_url).to eq group_posts_url(group)
				expect(page).to_not have_content 'An Old Group Message'
				expect(page).to have_content 'Updated Group Message!!!'
			end

			scenario 'when deleting group message' do
				visit group_posts_url(group)

				expect(page).to have_content existing_group_message.subject

				click_on 'Delete'

				expect(page).to have_content "Your message was removed. Now you have #{user.credits} points"
				expect(current_url).to eq group_posts_url(group)
				expect(page).not_to have_content 'An Old Group Message'
			end
		end

		context 'News Items' do
			let!(:image) { File.new('spec/fixtures/files/verizon_logo.png') }
			let!(:existing_news_item) { create(:news_link, title: 'An Old Group News Item',
			 description: 'Brief description of News Item', group_id: group.id, picture: image, author_id: user.id) }

			before { visit group_posts_path(group) }

			scenario 'when creating news items with url', js: true do
				expect(page).to have_link '+ Create News'

				click_on '+ Create News'

				expect(page).to have_content 'Add news'

				fill_in 'news_link[url]', with: 'https://wwww.viz.com/naruto'
				fill_in 'news_link[title]', with: 'Latest News'
				fill_in 'news_link[description]', with: 'Naruto is the Seventh Hokage!!!'
				click_on 'Add a photo'
				attach_file('File', 'spec/fixtures/files/verizon_logo.png')

				click_on 'Create News link'

				expect(current_path).to eq group_posts_path(group)
				expect(page).to have_content 'Latest News'
			end
		end
	end

	context 'when enteprise has pending comments disabled'
end