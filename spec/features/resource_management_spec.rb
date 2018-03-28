require 'rails_helper'

RSpec.feature 'Resource management' do
	let!(:user) { create(:user) }

	before do
		login_as(user, scope: :user)
	end

	context 'create a new folder' do
		before do
			visit enterprise_folders_url(user.enterprise)
			expect(page).to have_content 'Folders'
			visit new_enterprise_folder_url(user.enterprise)

			expect(current_url).to eq new_enterprise_folder_url(user.enterprise)
			expect(page).to have_content 'Create a folder'
		end

		scenario 'with password protection' do
			fill_in 'folder[name]', with: 'Top Secret'
			check 'Password Protected?'
			fill_in 'folder[password]', with: 'password_1'

			click_on 'Create Folder'

			expect(current_url).to eq enterprise_folders_url(user.enterprise)
			expect(page).to have_content  'Top Secret'
			folder = Folder.find_by(name: 'Top Secret')
			expect(folder.password_protected?).to eq true

		end

		scenario 'without password protection' do
			fill_in 'folder[name]', with: 'Top Secret'

			click_on 'Create Folder'

			expect(current_url).to eq enterprise_folders_url(user.enterprise)
			expect(page).to have_content 'Top Secret'
			folder = Folder.find_by(name: 'Top Secret')
			expect(folder.password_protected?).to eq false
		end
	end
end