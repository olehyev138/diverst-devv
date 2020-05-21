require 'rails_helper'

RSpec.feature 'Initiative filtering' do
  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:annual_budget) { create(:annual_budget, group_id: group.id) }
  let(:outcome) { create :outcome, group_id: group.id }
  let(:pillar) { create :pillar, outcome_id: outcome.id }
  let!(:initiative) { create :initiative, pillar: pillar, owner_group: group, start: Date.yesterday, end: Date.tomorrow, annual_budget_id: annual_budget.id }
  let!(:initiative2) { create :initiative, pillar: pillar, owner_group: group, start: Date.tomorrow, end: Date.tomorrow + 5.days, annual_budget_id: annual_budget.id }
  let!(:initiative3) { create :initiative, pillar: pillar, owner_group: group, start: 2.years.ago, end: 2.years.ago + 1.week, annual_budget_id: annual_budget.id }
  let!(:initiative4) { create :initiative, pillar: pillar, owner_group: group, start: 1.year.from_now, end: 1.year.from_now + 3.days, annual_budget_id: annual_budget.id }

  before(:each) do
    login_as(user, scope: :user, run_callbacks: false)
    group.members << user
    visit group_initiatives_path(group)
  end

  scenario 'shows correct initiatives with default filter' do
    expect(page).to have_content initiative.name
    expect(page).to have_content initiative2.name
    expect(page).not_to have_content initiative3.name
    expect(page).not_to have_content initiative4.name
  end

  scenario 'shows correct initiatives with modified filter' do
    fill_in 'initiative_from', with: 8.months.from_now.strftime('%Y-%m-%d')
    fill_in 'initiative_to', with: (1.year.from_now + 1.day).strftime('%Y-%m-%d')
    click_on 'Filter'

    expect(page).to have_content initiative4.name
    expect(page).not_to have_content initiative.name
    expect(page).not_to have_content initiative2.name
    expect(page).not_to have_content initiative3.name
  end
end
