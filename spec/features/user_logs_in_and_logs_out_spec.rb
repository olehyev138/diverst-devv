require 'rails_helper'

RSpec.feature 'User logs in/out ' do
  let!(:user) { create(:user) }

  context 'Login Behavior' do
    scenario 'users see an error message on invalid login' do
      user_logs_in_with_incorrect_credentials

      expect(page).to have_content 'Invalid email or password.'
    end

    scenario 'users get redirected to the metrics dashboard on successful login' do
      user_logs_in_with_correct_credentials(user)

      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'non-admin users do not see dashboard link' do
      non_admin_policy_group = create(:policy_group, admin_pages_view: false)
      non_admin_user = create(:user, enterprise_id: user.enterprise_id, policy_group_id: non_admin_policy_group.id)

      user_logs_in_with_correct_credentials(non_admin_user)

      expect(page).to have_content 'Signed in successfully'
      expect(page).to have_no_content 'Admin Dashboard'
    end

    scenario 'admin user see dashboard link' do
      user_logs_in_with_correct_credentials(user)

      expect(page).to have_content 'Signed in successfully'
      expect(page).to have_content 'Admin Dashboard'
    end
  end
end
