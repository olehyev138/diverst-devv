require 'rails_helper'

RSpec.feature 'Folder management' do
  let!(:user) { create(:user) }
  let!(:folder_with_pp) { create(:folder, enterprise: user.enterprise, name: 'Company Archives',
                                          password_protected: true, password: 'password_2')
  }
  let!(:folder_without_pp) { create(:folder, enterprise: user.enterprise, name: 'Company Documents',
                                             password_protected: false)
  }
  let!(:group) { create(:group, name: 'New Group', enterprise_id: user.enterprise_id) }

  before { login_as(user, scope: :user) }


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

    scenario 'and share new folder with group' do
      fill_in 'folder[name]', with: 'Top Secret'
      check 'Password Protected?'
      fill_in 'folder[password]', with: 'password_1'
      select group.name, from: 'folder[group_ids][]'

      click_on 'Create Folder'

      visit group_folders_url(group)

      expect(page).to have_content 'Top Secret'
      expect(page).to have_no_content 'Company Archives'
      expect(page).to have_no_content 'Company Documents'
    end

    scenario 'move new folder into existing folder' do
      fill_in 'folder[name]', with: 'Top Secret'
      select folder_with_pp.name, from: 'folder[parent_id]'
      check 'Password Protected?'
      fill_in 'folder[password]', with: 'password_1'

      click_on 'Create Folder'

      folder = Folder.find_by(name: 'Top Secret')
      expect(current_url).to eq enterprise_folder_resources_url(user.enterprise, folder_with_pp)

      within('h1') do
        expect(page).to have_content folder_with_pp.name
      end

      within('h4') do
        expect(page).to have_content folder.name
      end
    end
  end


  context 'update existing folder' do
    before do
      visit enterprise_folder_resources_url(user.enterprise, folder_without_pp)
    end

    scenario 'by changing folder name' do
      within find('.container-fluid') do
        click_on 'Edit Folder'
      end

      within('h1') do
        expect(page).to have_content 'Edit a folder'
      end
      expect(page).to have_field('folder[name]', with: folder_without_pp.name)

      fill_in 'folder[name]', with: 'Company Files'

      click_on 'Update Folder'

      expect(current_url).to eq enterprise_folders_url(user.enterprise)
      expect(page).to have_content 'Company Files'
      expect(page).to have_no_content 'Company Documents'
    end

    scenario 'by adding password protection to folder' do
      within find('.container-fluid') do
        click_on 'Edit Folder'
      end

      within('h1') do
        expect(page).to have_content 'Edit a folder'
      end
      expect(page).to have_field('folder[name]', with: folder_without_pp.name)

      expect(folder_without_pp.password_protected?).to eq false

      check 'Password Protected?'
      fill_in 'folder[password]', with: 'password_one'

      click_on 'Update'

      folder_without_pp.reload
      expect(current_url).to eq enterprise_folders_url(user.enterprise)
      expect(folder_without_pp.password_protected?).to eq true
    end

    scenario 'and add another folder' do
      click_on '+ Add folder'

      expect(current_url).to eq new_enterprise_folder_url(user.enterprise, folder_id: folder_without_pp.id)
      expect(page).to have_select('folder[parent_id]')

      fill_in 'folder[name]', with: 'Sub Folder 1'

      click_on 'Create Folder'

      sub_folder = Folder.find_by(name: 'Sub Folder 1')
      expect(current_url).to eq enterprise_folder_resources_url(user.enterprise, folder_without_pp)

      within('h1') do
        expect(page).to have_content folder_without_pp.name
      end

      within('h4') do
        expect(page).to have_content sub_folder.name
      end
    end

    scenario 'and share folder with group' do
      within find('.container-fluid') do
        click_on 'Edit Folder'
      end

      expect(current_url).to eq edit_enterprise_folder_url(user.enterprise, folder_without_pp)
      expect(page).to have_content 'Edit a folder'

      select group.name, from: 'folder[group_ids][]'

      click_on 'Update Folder'

      visit group_folders_url(group)

      expect(page).to have_content folder_without_pp.name
    end
  end

  context 'delete existing' do
    before { visit enterprise_folders_url(user.enterprise) }

    scenario 'folder' do
      expect(page).to have_content folder_without_pp.name

      click_link 'Delete', href: enterprise_folder_path(user.enterprise, folder_without_pp)

      expect(page).to have_no_content folder_without_pp.name
    end

    scenario 'sub folder' do
      sub_folder = create(:folder, name: 'Sub Folder', parent_id: folder_without_pp.id, enterprise: user.enterprise)

      visit enterprise_folder_resources_url(user.enterprise, folder_without_pp)

      expect(page).to have_content sub_folder.name

      click_on 'Delete'

      expect(page).to have_no_content sub_folder.name
    end
  end
end
