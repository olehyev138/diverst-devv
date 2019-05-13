require 'rails_helper'

RSpec.feature 'User Management' do
  let!(:enterprise) { create(:enterprise, time_zone: 'UTC') }
  let!(:admin_user) { create(:user, enterprise: enterprise) }
  let!(:guest_user) { create(:user, enterprise: enterprise) }

  before do
    enterprise.fields.destroy_all

    login_as(admin_user, scope: :user)
    visit users_path
  end

  context 'manage users' do
    scenario 'add a user', js: true, skip: 'JS errors causing tests to fail - possible issue with Poltergeist/PhantomJS being outdated' do
      click_on 'Add a user'

      fill_user_invitation_form(with_custom_fields: false)

      expect(current_path).to eq users_path
      expect(page).to have_content 'derek@diverst.com'
    end

    context 'add a user' do
      before do
        set_custom_text_fields
        visit edit_fields_enterprise_path(enterprise)
      end

      scenario 'with custom-fields', js: true, skip: 'JS errors causing tests to fail - possible issue with Poltergeist/PhantomJS being outdated' do
        visit users_path

        click_on 'Add a user'

        fill_user_invitation_form(with_custom_fields: true)

        expect(current_path).to eq users_path
        expect(page).to have_content 'derek@diverst.com'
      end
    end

    scenario 'edit user', js: true, skip: 'FAILS CONSISTENTLY' do
      click_link 'Detail', href: user_path(guest_user)

      click_on 'Edit User'

      expect(page).to have_field('user[email]', with: guest_user.email)

      fill_in 'user[email]', with: 'new@email.com'

      click_on 'Save'

      expect(page).to have_content 'Your user was updated'
      expect(page).to have_field('user[email]', with: 'new@email.com')
    end

    scenario 'remove user when user is not current_user from enterprise', js: true, skip: 'JS errors causing tests to fail - possible issue with Poltergeist/PhantomJS being outdated' do
      page.accept_confirm(with: 'Are you sure?') do
        click_link 'Remove', href: user_path(guest_user)
      end

      expect(page).to have_no_content guest_user.first_name
    end

    scenario 'do not allow user to be deleted if current_user' do
      expect(page).to have_no_link 'Remove'
    end

    context 'for an existing user' do
      before do
        set_custom_text_fields
        visit edit_fields_enterprise_path(enterprise)
      end

      scenario 'revoke invitation', js: true, skip: 'JS errors causing tests to fail - possible issue with Poltergeist/PhantomJS being outdated' do
        visit users_path

        click_on 'Add a user'

        fill_user_invitation_form(with_custom_fields: true)

        user = User.find_by(email: 'derek@diverst.com')

        page.accept_confirm(with: 'Are you sure?') do
          click_link('Revoke invitation', href: user_path(user))
        end

        expect(page).to have_no_content 'derek@diverst.com'
      end

      scenario 're-send invitation', js: true, skip: 'JS errors causing tests to fail - possible issue with Poltergeist/PhantomJS being outdated' do
        visit users_path

        click_on 'Add a user'

        fill_user_invitation_form(with_custom_fields: true)

        user = User.find_by(email: 'derek@diverst.com')

        page.accept_confirm(with: 'Are you sure? ') do
          click_link 'Re-send invitation', href: resend_invitation_user_path(user)
        end

        expect(page).to have_content 'Invitation Re-Sent!'
      end
    end
  end
end
