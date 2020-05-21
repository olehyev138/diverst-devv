require 'rails_helper'

RSpec.feature 'Resource management' do
  let!(:user) { create(:user) }
  let!(:folder_with_pp) { create(:folder, enterprise: user.enterprise, name: 'Company Archives',
                                          password_protected: true, password: 'pAsSwOrD')
  }
  let!(:folder_without_pp) { create(:folder, enterprise: user.enterprise, name: 'Company Documents',
                                             password_protected: false)
  }
  let!(:group) { create(:group, name: 'New Group', enterprise_id: user.enterprise_id) }

  before { login_as(user, scope: :user) }

  context 'create a new resource' do
    before do
      visit enterprise_folder_resources_path(user.enterprise, folder_without_pp)

      expect(page).to have_link '+ Add resource'
      click_on '+ Add resource'

      expect(page).to have_content 'Create a resource'

      fill_in 'resource[title]', with: 'Advanced Genetic Research'
      attach_file('resource[file]', 'spec/fixtures/files/verizon_logo.png')
    end

    scenario 'within same folder' do
      select folder_without_pp.name, from: 'resource[folder_id]'

      click_on 'Create Resource'

      expect(current_path).to eq enterprise_folder_resources_path(user.enterprise, folder_without_pp)
      expect(page).to have_content 'Advanced Genetic Research'
    end

    scenario 'with url' do
      select folder_without_pp.name, from: 'resource[folder_id]'

      fill_in 'resource[url]', with: 'https://www.viz.com/naruto'

      click_on 'Create Resource'

      expect(current_path).to eq enterprise_folder_resources_path(user.enterprise, folder_without_pp)
      expect(page).to have_link 'Link'

      click_on 'Link'
      expect(current_url).to eq 'https://www.viz.com/naruto'
    end

    scenario 'without a url' do
      select folder_without_pp.name, from: 'resource[folder_id]'

      click_on 'Create Resource'

      expect(current_path).to eq enterprise_folder_resources_path(user.enterprise, folder_without_pp)
      expect(page).not_to have_link 'Link'
      expect(page).to have_content 'N/A'
    end

    scenario 'with tags'
    scenario 'without tags'
  end

  context 'update and destroy' do
    let!(:verizon_logo) { File.new('spec/fixtures/files/verizon_logo.png') }
    let!(:resource_with_url) { create(:resource, title: 'Official Website of Naruto Shippuden',
                                                 folder: folder_with_pp, file: verizon_logo, url: 'https://www.viz.com/naruto')
    }
    let!(:resource_without_url) { create(:resource, title: 'Dragon Ball Z', folder: folder_without_pp,
                                                    file: verizon_logo, url: '')
    }

    context 'update existing resource' do
      scenario 'and move to a different folder' do
        visit enterprise_folder_resources_path(user.enterprise, folder_without_pp)

        expect(page).to have_content resource_without_url.title

        click_on 'Edit'

        expect(page).to have_content 'Edit a resource'
        expect(page).to have_field('title', with: resource_without_url.title)

        select folder_with_pp.name, from: 'resource[folder_id]'

        click_on 'Update Resource'

        expect(current_path).to eq enterprise_folder_resources_path(user.enterprise, folder_without_pp)

        expect(page).to have_no_content resource_without_url.title

        visit enterprise_folder_resources_path(user.enterprise, folder_with_pp)

        expect(page).to have_content resource_without_url.title
      end

      scenario 'with url' do
        visit enterprise_folder_resources_path(user.enterprise, folder_without_pp)

        expect(page).to have_content resource_without_url.title

        click_on 'Edit'

        expect(page).to have_content 'Edit a resource'

        fill_in 'resource[title]', with: 'FC BARCELONA Official Website'
        fill_in 'resource[url]', with: 'https://www.fcbarcelona.com'

        click_on 'Update Resource'

        resource_without_url.reload

        expect(page).to have_content 'FC BARCELONA Official Website'
        expect(page).to have_link 'Link'
      end
    end

    context 'Delete existing resource' do
      scenario 'from existing folder', js: true do
        visit enterprise_folder_resources_path(user.enterprise, folder_without_pp)

        expect(page).to have_content resource_without_url.title

        page.accept_confirm(with: 'Are you sure?') do
          click_on 'Delete'
        end

        expect(page).to have_no_content resource_without_url.title
      end
    end
  end
end
