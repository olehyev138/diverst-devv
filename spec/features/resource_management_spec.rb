require 'rails_helper'

RSpec.feature 'Resource management' do
	let!(:user) { create(:user) }
	let!(:folder_with_pp) { create(:folder, container: user.enterprise, name: 'Company Archives',
		password_protected: true, password: 'pAsSwOrD') }
	let!(:folder_without_pp) { create(:folder, container: user.enterprise, name: 'Company Documents',
		password_protected: false) }
	let!(:group) { create(:group, name: 'New Group', enterprise_id: user.enterprise_id) }

	before { login_as(user, scope: :user) }

	context 'create a new resource' do
		before do
			visit enterprise_folder_resources_url(user.enterprise, folder_without_pp)

			expect(page).to have_content '+ Add resource'
			click_on '+ Add resource'

			expect(page).to have_content 'Create a resource'

			fill_in 'resource[title]', with: 'Advanced Genetic Research'
			attach_file('resource[file]', 'spec/fixtures/files/verizon_logo.png')
		end

		scenario 'and move to a different folder' do
			pending 'this is a buggy feature and currently fails'

			select folder_with_pp.name, from: 'resource[container_id]'

			click_on 'Create Resource'

			expect(current_url).to eq enterprise_folder_resources_url(user.enterprise, folder_with_pp)
			expect(page).to have_content 'Advanced Genetic Research'
		end

		scenario 'within same folder' do
			select folder_without_pp.name, from: 'resource[container_id]'

			click_on 'Create Resource'

			expect(current_url).to eq enterprise_folder_resources_url(user.enterprise, folder_without_pp)
			expect(page).to have_content 'Advanced Genetic Research'
		end

		scenario 'with url' do
			select folder_without_pp.name, from: 'resource[container_id]'

			fill_in 'resource[url]', with: 'https://www.viz.com/naruto'

			click_on 'Create Resource'

			expect(current_url).to eq enterprise_folder_resources_url(user.enterprise, folder_without_pp)
			expect(page).to have_link 'Link'

			click_on 'Link'
			expect(current_url).to eq 'https://www.viz.com/naruto'
		end

		scenario 'without a url' do
			select folder_without_pp.name, from: 'resource[container_id]'

			click_on 'Create Resource'

			expect(current_url).to eq enterprise_folder_resources_url(user.enterprise, folder_without_pp)
			expect(page).not_to have_link 'Link'
			expect(page).to have_content 'N/A'
		end
	end
end