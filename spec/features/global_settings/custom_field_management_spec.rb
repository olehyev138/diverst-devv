require 'rails_helper'

RSpec.feature 'Custom-field Management' do
  let!(:enterprise) { create(:enterprise, time_zone: 'UTC') }
  let!(:admin_user) { create(:user, enterprise: enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }

  before do
    enterprise.fields.destroy_all

    login_as(admin_user)
    visit edit_fields_enterprise_path(enterprise)
  end

  context 'TextField' do
    scenario 'add custom text field without multiple lines(type: text)', js: true do
      click_on 'Add text field'

      expect_new_text_field_form

      fill_in '* Title', with: 'BIO'

      page.find_field('Allow user to edit').trigger('click')

      click_on 'Save user fields'

      expect(page).to have_content 'BIO'

      visit new_user_invitation_path
      id = TextField.last.id

      expect(page).to have_field("bio_#{id}", type: 'text')
    end

    scenario 'add custom text field with multiple lines(type: textarea)', js: true do
      click_on 'Add text field'

      expect_new_text_field_form

      fill_in '* Title', with: 'Detailed BIO'
      page.find_field('Allow multiple lines').trigger('click')

      page.find_field('Allow user to edit').trigger('click')

      click_on 'Save user fields'

      expect(page).to have_content 'Detailed BIO'

      visit new_user_invitation_path
      id = TextField.last.id

      expect(page).to have_field("detailed bio_#{id}", type: 'textarea')
    end

    context 'remove' do
      before do
        set_custom_text_fields
        visit edit_fields_enterprise_path(enterprise)
      end

      scenario 'custom text field', js: true do
        expect(page).to have_content 'BIO'

        click_on 'Remove'

        click_on 'Save user fields'

        expect(page).to have_no_content 'BIO'
      end
    end

    context 'edit' do
      before do
        @field = set_custom_text_fields
        visit edit_fields_enterprise_path(enterprise)
        click_on 'Edit'
      end

      scenario 'custom text field', js: true do
        expect(page).to have_field('* Title', with: 'BIO')
        expect(page).to have_unchecked_field('Allow multiple lines')
        expect(page).to have_unchecked_field('Hide from users')
        expect(page).to have_unchecked_field('Allow user to edit')
        expect(page).to have_unchecked_field('Set as mandatory')
        expect(page).to have_unchecked_field('Show field in member list')
        expect(page).to have_field('Saml attribute', with: '')

        fill_in '* Title', with: 'Brief Self Description'
        page.find_field('Allow multiple lines').trigger('click')

        click_on 'Save user fields'

        expect(page).to have_content 'Brief Self Description'
        expect(page).to have_no_content 'BIO'
      end

      scenario 'custom text field by hiding from user profile', js: true do
        page.find_field('Hide from users').trigger('click')

        click_on 'Save user fields'

        visit user_path(user)

        expect(page).to have_content 'BIO'

        click_on 'Edit User'

        expect(page).to have_no_content 'BIO'
      end

      scenario 'custom text field by making it mandatory', js: true do
        page.find_field('Set as mandatory').trigger('click')

        click_on 'Save user fields'

        visit edit_user_user_path(admin_user)

        expect(page).to have_content('* Bio')
      end

      scenario 'custom text field by making it part of CSV member list', js: true do
        expect(Field.find(@field.id).add_to_member_list).to eq false

        page.find_field('Show field in member list').trigger('click')

        click_on 'Save user fields'

        expect(Field.find(@field.id).add_to_member_list).to eq true

        visit edit_fields_enterprise_path(enterprise)

        click_on 'Edit'

        expect(Field.find(@field.id).add_to_member_list).to eq true

        page.find_field('Show field in member list').trigger('click')

        click_on 'Save user fields'

        expect(Field.find(@field.id).add_to_member_list).to eq false
      end
    end
  end

  context 'SelectField' do
    scenario 'add custom select field to user', js: true do
      click_on 'Add select field'

      expect_new_select_field_form

      fill_in '* Title', with: 'Countries'
      fill_in 'Options (one per line)', with: "Spain\nArgentina\nBrazil\nGermany\nCanada"

      page.find_field('Allow user to edit').trigger('click')

      click_on 'Save user fields'

      expect(page).to have_content 'Countries'

      visit edit_user_user_path(admin_user)
      id = SelectField.last.id

      expect(page).to have_select("countries_#{id}", with_options: ['Spain', 'Argentina', 'Brazil', 'Germany', 'Canada'])
    end

    context 'remove' do
      before do
        @field = set_custom_select_fields
        visit edit_fields_enterprise_path(enterprise)
      end

      scenario 'custom select field from user', js: true do
        expect(page).to have_content 'Gender'

        click_on 'Remove'

        click_on 'Save user fields'

        expect(page).to have_no_content 'Gender'
      end
    end

    context 'edit' do
      before do
        @field = set_custom_select_fields
        visit edit_fields_enterprise_path(enterprise)
        click_on 'Edit'
      end

      scenario 'custom select field', js: true do
        expect(page).to have_content 'Gender'

        expect(page).to have_unchecked_field('Hide from users')
        expect(page).to have_unchecked_field('Allow user to edit')
        expect(page).to have_unchecked_field('Set as mandatory')
        expect(page).to have_unchecked_field('Show field in member list')

        expect(page).to have_field('* Title', with: 'Gender', type: 'text')
        fill_in '* Title', with: 'Sex'

        click_on 'Save user fields'

        expect(page).to have_content 'Sex'
        expect(page).to have_no_content 'Gender'
      end

      scenario 'custom select field by hiding it from user profile', js: true do
        expect(page).to have_content 'Gender'

        page.find_field('Hide from users').trigger('click')

        click_on 'Save user fields'

        visit user_path(user)

        expect(page).to have_content 'Gender'

        click_on 'Edit User'

        expect(page).to have_no_content 'Gender'
      end

      scenario 'custom select field by adding an extra option to choose from', js: true do
        fill_in 'Options (one per line)', with: "Male\nFemale\nOther"

        page.find_field('Allow user to edit').trigger('click')

        click_on 'Save user fields'

        visit edit_user_user_path(admin_user)
        id = SelectField.last.id

        expect(page).to have_select("gender_#{id}", with_options: ['Male', 'Female', 'Other'])
      end

      scenario 'custom select field by making it mandatory', js: true do
        page.find_field('Set as mandatory').trigger('click')

        click_on 'Save user fields'

        visit edit_user_user_path(admin_user)

        expect(page).to have_content '* Gender'
      end

      scenario 'custom select field by making it part of CSV member list', js: true do
        expect(Field.find(@field.id).add_to_member_list).to eq false

        page.find_field('Show field in member list').trigger('click')

        click_on 'Save user fields'

        expect(Field.find(@field.id).add_to_member_list).to eq true

        visit edit_fields_enterprise_path(enterprise)

        click_on 'Edit'

        expect(Field.find(@field.id).add_to_member_list).to eq true

        page.find_field('Show field in member list').trigger('click')

        click_on 'Save user fields'

        expect(Field.find(@field.id).add_to_member_list).to eq false
      end
    end
  end

  context 'CheckboxField' do
    scenario 'add custom checkbox field to user', js: true do
      click_on 'Add checkbox field'

      expect_new_checkbox_field_form

      fill_in '* Title', with: 'Programming Language'
      fill_in 'Options (one per line)', with: "Ruby\nElixir\nC++\nJavaScript"

      page.find_field('Allow user to edit').trigger('click')

      click_on 'Save user fields'

      expect(page).to have_content 'Programming Language'

      visit edit_user_user_path(admin_user)

      expect(page).to have_unchecked_field('Ruby', type: 'checkbox')
      expect(page).to have_unchecked_field('Elixir', type: 'checkbox')
      expect(page).to have_unchecked_field('C++', type: 'checkbox')
      expect(page).to have_unchecked_field('JavaScript', type: 'checkbox')
    end

    context 'remove' do
      before do
        @field = set_custom_checkbox_fields
        visit edit_fields_enterprise_path(enterprise)
      end

      scenario 'custom checkbox field from user', js: true do
        expect(page).to have_content 'Programming Language'

        page.find_link('Remove', match: :first).click

        click_on 'Save user fields'

        expect(page).to have_no_content 'Programming Language'
      end
    end

    context 'edit' do
      before do
        @field = set_custom_checkbox_fields
        visit edit_fields_enterprise_path(enterprise)
        click_on 'Edit'
      end

      scenario 'custom checkbox field', js: true do
        expect(page).to have_unchecked_field('Hide from users')
        expect(page).to have_unchecked_field('Allow user to edit')
        expect(page).to have_unchecked_field('Set as mandatory')
        expect(page).to have_unchecked_field('Show field in member list')
        expect(page).to have_field('* Title', with: 'Programming Language')
        expect(page).to have_field('Options (one per line)', with: "Ruby\nElixir\nC++\nJavaScript")

        fill_in '* Title', with: 'Software Tools'

        click_on 'Save user fields'

        expect(page).to have_no_content 'Programming Language'
        expect(page).to have_content 'Software Tools'
      end

      scenario 'custom checkbox field whem using multi-select field option', js: true do
        expect(page).to have_unchecked_field('Use multi-select field', type: 'checkbox')

        page.find_field('Use multi-select field').trigger('click')

        page.find_field('Allow user to edit').trigger('click')

        click_on 'Save user fields'

        visit edit_user_user_path(admin_user)
        id = CheckboxField.last.id

        expect(page).to have_no_unchecked_field 'Ruby', type: 'checkbox'
        expect(page).to have_select("programming language_#{id}", with_options: ['Ruby', 'Elixir', 'C++', 'JavaScript'])
      end

      scenario 'custom checkbox field by hiding it from users profile', js: true do
        page.find_field('Allow user to edit').trigger('click')

        click_on 'Save user fields'

        visit edit_user_user_path(admin_user)

        expect(page).to have_content 'Programming Language'
        expect(page).to have_unchecked_field('Ruby', type: 'checkbox')

        visit edit_fields_enterprise_path(enterprise)
        click_on 'Edit'

        expect(page).to have_unchecked_field('Hide from users', type: 'checkbox')

        page.find_field('Hide from users').trigger('click')

        click_on 'Save user fields'

        visit edit_user_user_path(admin_user)

        expect(page).to have_no_content 'Programming Language'
        expect(page).to have_no_unchecked_field 'Ruby', type: 'checkbox'
      end

      scenario 'custom checkbox field by making it mandatory', js: true do
        page.find_field('Set as mandatory').trigger('click')

        click_on 'Save user fields'

        visit edit_user_user_path(admin_user)

        expect(page).to have_content ' * Programming Language'
      end

      scenario 'custom checkbox field by making it part of CSV member list', js: true do
        expect(Field.find(@field.id).add_to_member_list).to eq false

        page.find_field('Show field in member list').trigger('click')

        click_on 'Save user fields'

        expect(Field.find(@field.id).add_to_member_list).to eq true

        visit edit_fields_enterprise_path(enterprise)

        click_on 'Edit'

        expect(Field.find(@field.id).add_to_member_list).to eq true

        page.find_field('Show field in member list').trigger('click')

        click_on 'Save user fields'

        expect(Field.find(@field.id).add_to_member_list).to eq false
      end
    end
  end

  context 'NumericField' do
    scenario 'add custom numeric field to user profile', js: true do
      click_on 'Add numeric field'

      expect_new_numeric_field_form

      fill_in '* Title', with: 'Age-restrictions'
      fill_in 'Min', with: 18
      fill_in 'Max', with: 98

      click_on 'Save user fields'

      expect(page).to have_content 'Age-restrictions'
    end

    context 'edit' do
      before do
        @field = set_custom_numeric_fields
        visit edit_fields_enterprise_path(enterprise)
        click_on 'Edit'
      end

      scenario 'custom numeric field', js: true do
        expect(page).to have_unchecked_field('Hide from users')
        expect(page).to have_unchecked_field('Allow user to edit')
        expect(page).to have_unchecked_field('Set as mandatory')
        expect(page).to have_unchecked_field('Show field in member list')
        expect(page).to have_field('* Title', with: 'Age-restrictions')
        expect(page).to have_field('Min', with: 18, type: 'number')
        expect(page).to have_field('Max', with: 98, type: 'number')

        fill_in '* Title', with: 'Age-Limits'
        fill_in 'Min', with: 20
        fill_in 'Max', with: 100

        click_on 'Save user fields'

        expect(page).to have_no_content 'Age-restrictions'
        expect(page).to have_content 'Age-Limits'
      end

      scenario 'custom numeric field to show slider instead', js: true do
        page.find_field('Show slider instead').trigger('click')

        click_on 'Save user fields'

        visit edit_user_user_path(admin_user)

        expect(page).to have_content 'Age-restrictions 58'
        expect(page).to have_no_field 'Min', type: 'number'
        expect(page).to have_no_field 'Max', type: 'number'
      end

      scenario 'custom numeric field to hide from users', js: true do
        page.find_field('Hide from users').trigger('click')

        click_on 'Save user fields'

        visit edit_user_user_path(admin_user)

        expect(page).to have_no_content 'Age-restrictions'
      end

      scenario 'custom numeric field by making it mandatory', js: true do
        page.find_field('Set as mandatory').trigger('click')

        click_on 'Save user fields'

        visit edit_user_user_path(enterprise)

        expect(page).to have_content '* Age-restrictions'
      end

      scenario 'custom numeric field by making it part of CSV member list', js: true do
        expect(Field.find(@field.id).add_to_member_list).to eq false

        page.find_field('Show field in member list').trigger('click')

        click_on 'Save user fields'

        expect(Field.find(@field.id).add_to_member_list).to eq true

        visit edit_fields_enterprise_path(enterprise)

        click_on 'Edit'

        expect(Field.find(@field.id).add_to_member_list).to eq true

        page.find_field('Show field in member list').trigger('click')

        click_on 'Save user fields'

        expect(Field.find(@field.id).add_to_member_list).to eq false
      end
    end
  end

  context 'DateField' do
    scenario 'add custom date field to user profile form', js: true do
      click_on 'Add date field'

      expect_new_date_field_form

      fill_in '* Title', with: 'Date of Birth'

      click_on 'Save user fields'

      expect(page).to have_content 'Date of Birth'
    end

    context 'edit' do
      before do
        @field = set_custom_date_fields
        visit edit_fields_enterprise_path(enterprise)
        click_on 'Edit'
      end

      scenario 'custom date field', js: true do
        expect(page).to have_unchecked_field('Hide from users')
        expect(page).to have_unchecked_field('Allow user to edit')
        expect(page).to have_unchecked_field('Set as mandatory')
        expect(page).to have_unchecked_field('Show field in member list')
        expect(page).to have_field('* Title', with: 'Date of Birth')

        fill_in '* Title', with: 'DOB'

        click_on 'Save user fields'

        expect(page).to have_content 'DOB'
        expect(page).to have_no_content 'Date of Birth'
      end

      scenario 'custom date field by hiding from user profile', js: true do
        page.find_field('Hide from users').trigger('click')

        click_on 'Save user fields'

        visit user_path(user)

        expect(page).to have_content 'Date of Birth'

        visit edit_user_path(user)

        expect(page).to have_no_field '* Title', with: 'Date of Birth'
      end

      scenario 'custom date field by setting it as mandatory', js: true do
        page.find_field('Set as mandatory').trigger('click')

        click_on 'Save user fields'

        visit edit_user_user_path(admin_user)

        expect(page).to have_content '* Date of birth'
      end

      scenario 'custom date field by making it part of CSV member list', js: true do
        expect(Field.find(@field.id).add_to_member_list).to eq false

        page.find_field('Show field in member list').trigger('click')

        click_on 'Save user fields'

        expect(Field.find(@field.id).add_to_member_list).to eq true

        visit edit_fields_enterprise_path(enterprise)

        click_on 'Edit'

        expect(Field.find(@field.id).add_to_member_list).to eq true

        page.find_field('Show field in member list').trigger('click')

        click_on 'Save user fields'

        expect(Field.find(@field.id).add_to_member_list).to eq false
      end
    end
  end
end
