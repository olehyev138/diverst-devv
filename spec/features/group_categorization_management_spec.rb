require 'rails_helper'

RSpec.feature 'Group Categorization' do
  let!(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
  end

  context 'group category creation' do
    scenario 'creating a new group category' do
      visit view_all_group_categories_path

      click_on 'New Category'

      expect(page).to have_content 'Create A Category'

      fill_in 'group_category_type[name]', with: 'Provinces'
      fill_in 'group_category_type[category_names]', with: 'Eastern Province, Central Province,
			Northern Province, Western Province, Southern Province'

      click_on 'Save'

      expect(current_path).to eq view_all_group_categories_path
      expect(page).to have_content 'You just created a category named Provinces'

      expect(page).to have_content 'Provinces'
      expect(page).to have_link 'Eastern Province'
      expect(page).to have_link 'Central Province'
    end

    scenario 'Add a group category to an existing list of group categories' do
      programming_languages = create(:group_category_type, name: 'Programming Languages',
                                                           enterprise_id: user.enterprise_id)
      ruby = create(:group_category, group_category_type_id: programming_languages.id,
                                     enterprise_id: user.enterprise_id, name: 'Ruby')

      visit view_all_group_categories_path

      expect(page).to have_content 'Programming Languages'
      click_on '+'

      expect(page).to have_content 'Add Labels To Programming Languages'

      fill_in 'group_category_type[category_names]', with: 'Elixir, Python, C++'

      click_on 'Save'

      expect(page).to have_content 'You successfully added categories to Programming Languages'

      expect(page).to have_link 'Elixir'
      expect(page).to have_link 'C++'
    end
  end

  context 'Deleting category types and labels' do
    let!(:web_frameworks) { create(:group_category_type, name: 'Web Frameworks',
                                                         enterprise_id: user.enterprise_id)
    }

    before do
      ['Rails', 'Elixir', 'Django'].each do |web_framework|
        create(:group_category, group_category_type_id: web_frameworks.id,
                                enterprise_id: user.enterprise_id, name: web_framework)
      end
    end

    scenario 'Deleting a group categories with existing categories' do
      visit view_all_group_categories_path

      expect(page).to have_content 'Web Frameworks'
      expect(page).to have_link 'Rails'

      click_link 'Delete', href: group_category_type_path(web_frameworks)

      expect(page).to have_content 'Successfully deleted categories'

      expect(page).to have_no_content 'Web Frameworks'
      expect(page).to have_no_content 'Rails'
      expect(page).to have_no_content 'Elixir'
      expect(page).to have_no_content 'Django'
    end

    scenario 'Deleting a group category(label)' do
      visit view_all_group_categories_path

      expect(page).to have_content 'Web Frameworks'
      expect(page).to have_link 'Rails'

      click_link 'Delete', href: group_category_path(web_frameworks.group_categories.first)

      expect(page).to have_content 'Category successfully removed'
      expect(page).to have_no_content 'Rails'
    end
  end

  context 'Updating category type and labels' do
    let!(:web_frameworks) { create(:group_category_type, name: 'Web Frameworks',
                                                         enterprise_id: user.enterprise_id)
    }

    scenario 'Update name of category type' do
      visit edit_group_category_type_path(web_frameworks)

      expect(page).to have_content 'Edit Category Type'
      expect(page).to have_field('group_category_type[name]', with: 'Web Frameworks')

      fill_in 'group_category_type[name]', with: 'All Web Technologies'

      click_on 'Update'

      expect(page).to have_content 'Update category type name'
      expect(page).to have_content 'All Web Technologies'
      expect(page).to have_no_content 'Web Frameworks'
    end

    scenario 'Update name of category(label)' do
      elixir = create(:group_category, name: 'Elixir', group_category_type_id: web_frameworks.id, enterprise_id: user.enterprise_id)

      visit edit_group_category_path(elixir)

      expect(page).to have_content 'Change name of category'
      expect(page).to have_field('group_category[name]', with: 'Elixir')

      fill_in 'group_category[name]', with: 'Ruby'

      click_on 'Update'

      expect(page).to have_content 'Update category name'
      expect(page).to have_content 'Ruby'
      expect(page).to have_no_content 'Elixir'
    end
  end
end
