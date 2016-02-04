require 'rails_helper'

RSpec.feature 'Campaign management' do

  let(:admin) { create(:admin, owner: false) }

  before do
    login_as(admin, scope: :admin)
  end

  scenario 'Admin creates a new campaign', :js do
    campaign = {
      title: 'My Campaign',
      description: 'Look at that sweet campaign!',
      start_time: Time.zone.local(2015, 11, 10, 12, 30),
      end_time: Time.zone.local(2015, 11, 15, 12, 30)
    }

    visit new_campaign_path

    fill_in 'campaign_title', with: campaign[:title]
    fill_in 'campaign_description', with: campaign[:description]
    select campaign[:start_time].strftime('%-d'), from: 'campaign_start_3i'
    select campaign[:end_time].strftime('%-d'), from: 'campaign_end_3i'

    click_on 'Add question'
    find('.campaign_questions_title').set('First question')
    find('.campaign_questions_description').set("That's a cool question")

    click_on 'Create Campaign'

    expect(page.find('table').all('tr')[1]).to have_content campaign[:title]
  end

  scenario 'Admin deletes a campaign' do
    campaign = create(:campaign, enterprise: admin.enterprise, admin: admin)

    visit campaigns_path
    expect(page).to have_content(campaign.title)

    click_on 'Delete'

    expect(page).not_to have_content(campaign.title)
  end

  context 'Another admin creates a campaign' do
    scenario 'other admins can view it' do
      other_admin = create(:admin, enterprise: admin.enterprise)
      campaign = create(:campaign, enterprise: admin.enterprise, admin: other_admin)

      visit campaigns_path

      expect(page).to have_content(campaign.title)
    end

    scenario 'other admins can\'t edit or delete it' do
      other_admin = create(:admin, enterprise: admin.enterprise)
      campaign = create(:campaign, enterprise: admin.enterprise, admin: other_admin)

      visit campaigns_path

      expect(page).not_to have_content('Delete')
      expect(page).not_to have_content('Edit')
    end

    scenario 'owners can still edit it' do
      other_admin = create(:admin, enterprise: admin.enterprise)
      campaign = create(:campaign, enterprise: admin.enterprise, admin: other_admin)
      admin.update(owner: true)

      visit campaigns_path

      expect(page).to have_content('Delete')
      expect(page).to have_content('Edit')
    end
  end

end
