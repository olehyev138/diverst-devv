require "rails_helper"

RSpec.feature "Email management" do
  let (:admin) { create(:admin) }
  let! (:email) { create(:email, name: "Sweet email", enterprise: admin.enterprise) }

  before do
    login_as(admin, scope: :admin)
  end

  scenario "admins can see emails" do
    visit emails_path
    expect(page).to have_content "Sweet email"
  end
end