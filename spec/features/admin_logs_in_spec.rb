require "rails_helper"

RSpec.feature "Admin logs in" do
  scenario "they see an error message on invalid login" do
    visit root_path
    fill_in "admin_email", with: "idontexist@diverst.com"
    fill_in "admin_password", with: "wh4t3v3r"
    click_on "Log in"

    expect(page).to have_content "Invalid email or password."
  end

  scenario "they get redirected to the metrics dashboard on successful login" do
    admin = create(:admin)

    login_as(admin, :scope => :admin)
    visit root_path

    expect(page).to have_content "General metrics"
  end
end