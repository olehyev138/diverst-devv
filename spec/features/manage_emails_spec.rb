require "rails_helper"

RSpec.feature "Email management" do
  let (:admin) { create(:admin) }
<<<<<<< HEAD
  let! (:email) { create(:email, name: "Sweet email", enterprise: admin.enterprise) }
=======
  let! (:email) { create(:email, name: "Sweet email") }
>>>>>>> 419856bf8a245c116c0d27bb483da12dfc794b5e

  before do
    login_as(admin, scope: :admin)
  end

  scenario "admins can see emails" do
    visit emails_path
    expect(page).to have_content "Sweet email"
  end
end