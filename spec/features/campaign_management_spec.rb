require 'rails_helper'

RSpec.feature 'Campaign management' do
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user, run_callbacks: false)
  end

  scenario 'user creates a new campaign', :js do
    create(:group, enterprise: user.enterprise, name: 'Group #1')

    policy_group = user.policy_group
    policy_group.campaigns_index = true
    policy_group.campaigns_create = true
    policy_group.campaigns_manage = true
    policy_group.save!

    campaign = {
      title: 'My Campaign',
      description: 'Look at that sweet campaign!',
      start_time: Date.today + 1,
      end_time: Date.today + 7,
      group_ids: [create(:group).id]
    }

    visit new_campaign_path

    fill_in 'campaign_title', with: campaign[:title]
    fill_in 'campaign_description', with: campaign[:description]
    fill_in 'campaign_start', with: campaign[:start_time]
    fill_in 'campaign_end', with: campaign[:end_time]
    select 'Group #1', from: 'campaign_group_ids'

    # We used 'trigger' instead of 'click_on' because Capybara raises an error when
    # we try to click on this button in a page that we have a datetime_picker input
    find('.add_fields', text: 'Add question').trigger('click')
    find('.campaign_questions_title').set('First question')
    find('.campaign_questions_description').set("That's a cool question")

    find('button[type="submit"][value="published"]').trigger('click')

    expect(page.find('table').all('tr')[1]).to have_content campaign[:title]
  end

  scenario 'user deletes a campaign', js: true do
    campaign = create(:campaign, enterprise: user.enterprise, owner: user)

    visit campaigns_path
    expect(page).to have_content(campaign.title)

    page.accept_confirm(with: 'Are you sure?') do
      click_on 'Delete'
    end
    expect(page).to have_no_content(campaign.title)
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
