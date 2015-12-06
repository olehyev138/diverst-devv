require "rails_helper"

RSpec.feature "Campaign management" do
  let (:admin) { create(:admin) }

  before do
    login_as(admin, scope: :admin)
  end

  scenario "Admin creates a new campaign", :js do
    campaign = {
      title: "My Campaign",
      description: "Look at that sweet campaign!",
      start_time: DateTime.new(2015, 11, 10, 12, 30),
      end_time: DateTime.new(2015, 11, 15, 12, 30),
    }

    visit new_campaign_path

    fill_in "campaign_title", with: campaign[:title]
    fill_in "campaign_description", with: campaign[:description]
    select campaign[:start_time].strftime("%-d"), from: "campaign_start_3i"
    select campaign[:end_time].strftime("%-d"), from: "campaign_end_3i"

    click_on "Add question"
    find(".campaign_questions_title").set("First question")
    find(".campaign_questions_description").set("That's a cool question")

    click_on "Create Campaign"

    expect(page.find('table').all('tr')[1]).to have_content campaign[:title]
  end

  scenario "Admin deletes a campaign" do
    campaign = create(:campaign, enterprise: admin.enterprise)

    visit campaigns_path
    expect(page).to have_content(campaign.title)

    click_on "Delete"

    expect(page).not_to have_content(campaign.title)
  end
end