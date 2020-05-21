require 'rails_helper'

RSpec.feature 'Email management' do
  let(:user) { create(:user) }
  let!(:email) { create(:email, name: 'Sweet email', enterprise: user.enterprise) }

  before do
    login_as(user, scope: :user, run_callbacks: false)
  end

  scenario 'users can see emails' do
    visit emails_path
    expect(page).to have_content 'Sweet email'
  end
end
