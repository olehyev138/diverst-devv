require 'rails_helper'

RSpec.feature 'Segment management' do

  let(:user) { create(:user) }
  let!(:segment) { create(:segment_with_rules, enterprise: user.enterprise) }

  before do
    login_as(user, scope: :user, :run_callbacks => false)
    user.enterprise.fields << create(:enterprise_field, enterprise: user.enterprise)
  end

  scenario 'user creates a new segment', :js do
    segment = {
      name: 'My awesome segment'
    }

    visit new_segment_path
    fill_in 'segment_name', with: segment[:name]
    click_on "Add a criterion"
    select user.enterprise.fields.last.title, from: page.find('.custom-field select')[:id]
    select 'equals', from: page.find('.operator select')[:id]
    click_on 'Create Segment'
    

    expect(page).to have_content segment[:name]
  end

  scenario 'user deletes a segment' do
    visit segments_path
    click_on "Delete"

    expect(page).not_to have_content segment.name
  end

  context 'user is viewing a segment\'s details' do
    before do
      visit segment_path(segment)
    end

    scenario 'shows the rule list' do
      expect(page).to have_content JSON.parse(segment.rules.first.values)[0]
    end
  end

end
