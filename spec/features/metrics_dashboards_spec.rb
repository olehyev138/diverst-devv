require 'rails_helper'

RSpec.feature 'Admin visits the metrics section' do
  let(:admin) { create(:admin) }

  before do
    login_as(admin, scope: :admin)
  end

  scenario 'they see the created metrics dashboards' do
    create(:metrics_dashboard, enterprise: admin.enterprise, name: "Test Dashboard")

    visit metrics_dashboards_path

    expect(page).to have_content 'Test Dashboard'
  end

  scenario 'they can delete a metrics dashboard' do
    create(:metrics_dashboard, enterprise: admin.enterprise, name: "Test Dashboard")

    visit metrics_dashboards_path
    click_on 'Delete'

    expect(page).not_to have_content 'Test Dashboard'
  end

  scenario 'they can edit a metrics dashboard' do
    create(:metrics_dashboard, enterprise: admin.enterprise, name: "Test Dashboard")

    visit metrics_dashboards_path
    click_on 'Edit'
    fill_in 'metrics_dashboard_name', with: 'Allo'
    submit_form

    expect(page).to have_content 'Allo'
  end

  scenario 'they can add graphs to an existing metrics dashboard' do
    field1 = create(:field, type: 'CheckboxField', title: 'Field #1')
    field2 = create(:field, type: 'CheckboxField', title: 'Field #2')
    admin.enterprise = create(:enterprise, fields: [field1, field2])
    dashboard = create(:metrics_dashboard, enterprise: admin.enterprise, name: "Test Dashboard")

    visit metrics_dashboard_path(dashboard)
    click_on 'New Graph'
    select 'Field #1', from: 'graph_field_id'
    select 'Field #2', from: 'graph_aggregation_id'
    submit_form

    expect(page).to have_css '.graph'
  end
end
