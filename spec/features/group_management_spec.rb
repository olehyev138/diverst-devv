require 'rails_helper'

RSpec.feature 'Group management' do

  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
  end

  context 'creating a group' do
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

      select 'None', from: "group_parent_id"

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

      select parent_group.name, from: 'group_parent_id'

      click_on 'Create Group'
      expect(page).not_to have_content sub_group[:name]

      page.find('.nested_show').click

      expect(page).to have_content sub_group[:name]
    end
  end

  context 'updating a group' do
    scenario 'user updates group with sub-ergs' do
      group = create(:group, name: 'Latest Group', enterprise: user.enterprise)
      group1 = create(:group, name: 'Group One', enterprise: user.enterprise)
      group2 = create(:group, name: 'Group Two', enterprise: user.enterprise)

      visit edit_group_path(group)

      expect(page).to have_field('group_name', with: 'Latest Group')

      fill_in 'group_name', with: 'Parent Group'

      select group1.name, from: 'group_child_ids'
      select group2.name, from: 'group_child_ids'

      click_on 'Update Group'

      expect(current_path).to eq edit_group_path(group)

      visit groups_path

      expect(page).to have_content 'Parent Group'
      expect(page).not_to have_content 'Group One'
      expect(page).not_to have_content 'Group Two'

      expect(current_path).to eq groups_path
      expect(page).to have_link 'Show Sub-ERGs'

      click_on 'Show Sub-ERGs'

      expect(page).to have_css('.accent') do
        expect(page).to have_content group1.name
        expect(page).to have_content group2.name
      end
    end
  end

  context 'deleting a group' do
    let!(:parent_group) { create(:group, name: 'Parent Group', enterprise: user.enterprise) }
    let!(:sub_group1) { create(:group, name: 'Sub Group ONE', parent_id: parent_group.id, enterprise: user.enterprise) }
    let!(:sub_group2) { create(:group, name: 'Sub Group TWO', parent_id: parent_group.id, enterprise: user.enterprise) }

    scenario 'delete parent group with sub-ergs' do
      visit groups_path

      click_on 'Delete'

      expect(page).to have_content 'Your ERG was deleted'
      expect(page).not_to have_content 'Parent Group'
      expect(page).not_to have_content 'Sub Group ONE'
      expect(page).not_to have_content 'Sub Group TWO'
    end

    scenario 'delete a sub-group' do
      visit groups_path

      click_on 'Show Sub-ERGs'

      expect(page).to have_css('.accent') do
        expect(page).to have_content sub_group1.name
        expect(page).to have_content sub_group2.name
      end

      click_on 'Show Sub-ERGs'

      expect(page).to have_css('.accent') do
        click_on 'Delete'
      end

      expect(page).to have_css('.accent') do
        expect(page).not_to have_content sub_group1.name
        expect(page).to have_content sub_group2.name
      end

      expect(page).to have_content parent_group.name
    end
  end

  context 'group categorization' do
    let!(:parent_group) { create(:group, name: 'Parent Group', enterprise_id: user.enterprise_id,
      group_category_type_id: nil, group_category_id: nil) }
    let!(:sub_group1) { create(:group, name: 'Sub Group ONE', parent_id: parent_group.id, enterprise_id: user.enterprise_id,
      group_category_type_id: nil, group_category_id: nil) }
    let!(:sub_group2) { create(:group, name: 'Sub Group TWO', parent_id: parent_group.id, enterprise_id: user.enterprise_id,
      group_category_type_id: nil, group_category_id: nil) }

    let!(:color_codes) { create(:group_category_type, name: 'Color Codes', enterprise_id: user.enterprise_id) }
    let!(:red) { create(:group_category, name: 'Red', enterprise_id: user.enterprise_id,
      group_category_type_id: color_codes.id) }
    let!(:blue) { create(:group_category, name: 'Blue', enterprise_id: user.enterprise_id,
      group_category_type_id: color_codes.id) }

    let!(:regions) { create(:group_category_type, name: 'Regions', enterprise_id: user.enterprise_id) }
    let!(:eastern_province) { create(:group_category, name: 'Eastern Province', enterprise_id: user.enterprise_id,
      group_category_type_id: regions.id) }
    let!(:central_province) { create(:group_category, name: 'Central Province', enterprise_id: user.enterprise_id,
      group_category_type_id: regions.id) }

    scenario 'categorize sub-erg with wrong label via edit form' do
      visit groups_path

      expect(page).to have_link parent_group.name
      click_on 'Show Sub-ERGs'

      visit edit_group_path(sub_group1)

      expect(current_path).to eq edit_group_path(sub_group1)

      expect(page).to have_field('Name', with: sub_group1.name)
      expect(page).to have_select('Parent-Erg', selected: parent_group.name)
      expect(page).to have_select('Group category', selected: nil) #NOTE: here, nil stands in for 'None'

      select 'Red', from: 'Group category'
      click_on 'Update Group'

      expect(page).to have_content 'Your ERG was updated'
      expect(page).to have_select('Group category', selected: 'Red')
    end

    scenario 'mass categorization of sub-ergs' do
    end
  end
end