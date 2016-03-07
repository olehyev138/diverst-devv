require 'rails_helper'

RSpec.feature 'Campaign management' do

  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
  end

  scenario 'user creates a new campaign', :js do
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

  scenario 'user deletes a campaign' do
    campaign = create(:campaign, enterprise: user.enterprise, owner: user)

    visit campaigns_path
    expect(page).to have_content(campaign.title)

    click_on 'Delete'

    expect(page).not_to have_content(campaign.title)
  end

  context 'Another user creates a campaign' do
    scenario 'other users can view it' do
      other_user = create(:user, enterprise: user.enterprise)
      campaign = create(:campaign, enterprise: user.enterprise, owner: other_user)

      visit campaigns_path

      expect(page).to have_content(campaign.title)
    end

    scenario 'other users with manage all permission can edit or delete it' do
      other_user = create(:user, enterprise: user.enterprise)
      campaign = create(:campaign, enterprise: user.enterprise, owner: other_user)

      visit campaigns_path

      expect(page).to have_content('Delete')
      expect(page).to have_content('Edit')
    end
  end

end
