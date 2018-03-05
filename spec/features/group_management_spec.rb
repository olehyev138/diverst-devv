require 'rails_helper'

RSpec.feature 'Group management' do

  let!(:user) { create(:user) }

  before do
    login_as(user, scope: :user, :run_callbacks => false)
  end

  scenario 'user creates a new group' do
    group = {
      name: 'My awesome group',
      description: 'Look at that sweet group!'
    }

    visit new_group_path

    fill_in 'group_name', with: group[:name]
    fill_in 'group_description', with: group[:description]

    click_on 'Create Group'

    expect(page).to have_content group[:name]
  end

  scenario 'user deletes a group' do
    group = create(:group, enterprise: user.enterprise)

    visit groups_path

    click_on "Delete"

    expect(page).not_to have_content group.name
  end

end