require 'rails_helper'

RSpec.feature 'Resource management' do
	let!(:user) { create(:user) }
	let!(:folder_with_pp) { create(:folder, container: user.enterprise, name: "Company Archives", password_protected: true, password: "password_2") }
	let!(:folder_without_pp) { create(:folder, container: user.enterprise, name: "Company Documents", password_protected: false) }
	let!(:group) { create(:group, name: "New Group", enterprise_id: user.enterprise_id ) }

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

		scenario 'and share folder with group' do
			fill_in 'folder[name]', with: 'Top Secret'
			check 'Password Protected?'
			fill_in 'folder[password]', with: 'password_1'

			select group.name, from: 'folder[group_ids][]'

			click_on 'Create Folder'

			visit group_folders_url(group)
			expect(page).to have_content 'Top Secret'
			expect(page).not_to have_content 'Company Archives'
			expect(page).not_to have_content 'Company Documents'
		end
	end

	context 'update existing folder' do
	end

	context 'delete existing folder' do
	end
end