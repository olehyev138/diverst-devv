require 'rails_helper'

RSpec.feature 'Admin management' do

  let(:owner) { create(:admin) }

  before do
    login_as(owner, scope: :admin)
  end

  scenario 'Owners can create admins' do
    visit admins_path
    click_on 'New Admin'
    fill_in 'admin_first_name', with: 'Mister'
    fill_in 'admin_last_name', with: 'Ahmin'
    fill_in 'admin_email', with: 'misterahmin@gmail.com'
    fill_in 'admin_password', with: 'meowmeow'
    fill_in 'admin_password_confirmation', with: 'meowmeow'
    submit_form

    expect(page).to have_content 'Mister Ahmin'
  end

  scenario 'Owner can edit an admin\'s password' do
    admin = create(:admin, owner: false, enterprise: owner.enterprise)

    visit admins_path
    click_on 'Edit'
    fill_in 'admin_password', with: 'meowmeow'
    fill_in 'admin_password_confirmation', with: 'meowmeow'
    click_on 'Change password'

    admin.reload
    expect(admin.valid_password?('meowmeow')).to eq true
  end

  scenario 'Owner can delete admins' do
    admin = create(:admin, owner: false, enterprise: owner.enterprise)

    visit admins_path
    click_on 'Delete'

    expect(page).not_to have_selector 'table'
  end
end
