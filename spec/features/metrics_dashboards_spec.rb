require 'rails_helper'

RSpec.feature 'user visits the metrics section' do
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user, run_callbacks: false)
  end

  scenario 'they can\'t see metrics dashboards created by others' do
    create(:metrics_dashboard, enterprise: user.enterprise, owner: create(:user, enterprise: user.enterprise), name: 'Test Dashboard')

    visit metrics_metrics_dashboards_path

    expect(page).to have_no_content 'Test Dashboard'
  end


  scenario 'they can edit a metrics dashboard' do
    create(:metrics_dashboard, enterprise: user.enterprise, owner: user, name: 'Test Dashboard', groups: [create(:group, enterprise: user.enterprise)])

    visit metrics_metrics_dashboards_path
    click_on 'Edit'
    fill_in 'metrics_dashboard_name', with: 'Allo'
    submit_form

    expect(page).to have_content 'Allo'
  end

  scenario 'they can add graphs to an existing metrics dashboard', skip: true do
    field1 = create(:field, type: 'CheckboxField', title: 'Field #1')
    field2 = create(:field, type: 'CheckboxField', title: 'Field #2')
    user.enterprise = create(:enterprise, fields: [field1, field2])
    dashboard = create(:metrics_dashboard, enterprise: user.enterprise, owner: user, name: 'Test Dashboard')

    visit metrics_metrics_dashboard_path(dashboard)
    click_on 'New Graph'
    select 'Field #1', from: 'graph_field_id'
    select 'Field #2', from: 'graph_aggregation_id'
    submit_form

    expect(page).to have_css '.graph'
  end

  context 'metrics can be deleted' do
    let!(:test_dashboard) { create(:metrics_dashboard, enterprise: user.enterprise, owner: user, name: 'Test Dashboard', groups: [create(:group, enterprise: user.enterprise)]) }

    before { visit metrics_metrics_dashboards_path }

    scenario 'successfully' do
      click_link 'Delete', href: metrics_metrics_dashboard_path(test_dashboard)

      expect(page).to have_no_content 'Test Dashboard'
    end
  end
end
