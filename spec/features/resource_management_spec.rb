require 'rails_helper'

RSpec.feature 'Resource management' do
	let!(:user) { create(:user) }

	before do
		login_as(user, scope: :user)
		visit enterprise_folders_url(user.enterprise)
	end

	context 'create a new resource' do
		scenario 'successfully' do
			expect(page).to have_content 'Folders'

			visit new_enterprise_folder_url(user.enterprise)

			expect(current_url).to eq new_enterprise_folder_url(user.enterprise)
			expect(page).to have_content 'Create a folder'

			fill_in 'folder[name]', with: 'Top Secret'
		end
	end
end