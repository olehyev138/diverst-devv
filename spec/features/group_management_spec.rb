require 'rails_helper'

RSpec.feature 'Group management' do

  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
  end

  scenario 'user creates a new group' do
    group = {
      name: 'My awesome group',
      description: "Lorem Ipsum is simply dummy text of the printing
       and typesetting industry. Lorem Ipsum has been the industry's
       standard dummy text ever since the 1500s, when an unknown printer
       took a galley of type and scrambled it to make a type specimen book.
       It has survived not only five centuries, but also the leap into
       electronic typesetting, remaining essentially unchanged.",
      short_description: "Lorem Ipsum is simply dummy text of the printing
       and typesetting industry."
    }

    visit new_group_path

    fill_in 'group_name', with: group[:name]
    fill_in 'group_short_description', with: group[:short_description]
    fill_in 'group_description', with: group[:description]

    select 'None', from: "Parent-Erg"

    click_on 'Create Group'

    expect(page).to have_content group[:name]
  end

  scenario 'user creates a sub-group', js: true do
    parent_group = create(:group, name: "Parent Group", enterprise: user.enterprise)

    sub_group = {
      name: "first sub-group",
      description: "Lorem Ipsum is simply dummy text of the printing
       and typesetting industry. Lorem Ipsum has been the industry's
       standard dummy text ever since the 1500s, when an unknown printer
       took a galley of type and scrambled it to make a type specimen book.
       It has survived not only five centuries, but also the leap into
       electronic typesetting, remaining essentially unchanged.",
      short_description: "Lorem Ipsum is simply dummy text of the printing
       and typesetting industry."
     }

     visit new_group_path

     fill_in 'group_name', with: sub_group[:name]
     fill_in 'group_short_description', with: sub_group[:short_description]
     fill_in 'group_description', with: sub_group[:description]

     select parent_group.name, from: 'Parent-Erg'

     click_on 'Create Group'
     expect(page).not_to have_content sub_group[:name]

     page.find('.nested_show').click

     expect(page).to have_content sub_group[:name]
  end

  scenario 'user deletes a group' do
    group = create(:group, enterprise: user.enterprise)

    visit groups_path(group)

    click_on "Delete"

    expect(page).not_to have_content group.name
  end

end