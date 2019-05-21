require 'rails_helper'

RSpec.feature 'Segment management' do
  let(:user) { create(:user) }
  let!(:segment) { create(:segment_with_rules, enterprise: user.enterprise) }

  before do
    login_as(user, scope: :user, run_callbacks: false)
    user.enterprise.fields << create(:enterprise_field, enterprise: user.enterprise)
  end

  scenario 'user creates a new segment', :js, skip: 'JS errors causing tests to fail - possible issue with Poltergeist/PhantomJS being outdated' do
    segment = {
      name: 'My awesome segment'
    }

    visit new_segment_path
    fill_in 'segment_name', with: segment[:name]

    click_link 'add_field_rule'

    select user.enterprise.fields.last.title, from: page.find('.custom-field select')[:id]
    select 'equals', from: page.find('.operator select')[:id]

    click_on 'Create Segment'

    expect(page).to have_field('segment_name', with: segment[:name])
  end

  scenario 'user deletes a segment', js: true, skip: 'JS errors causing tests to fail - possible issue with Poltergeist/PhantomJS being outdated' do
    visit segments_path

    click_link 'Delete', href: segment_path(segment)

    expect(page).not_to have_content segment.name
  end
end
