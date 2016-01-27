require 'rails_helper'

RSpec.describe MetricsDashboardsController, '#index' do
  let!(:metrics_dashboard) { create(:metrics_dashboard) }
  let(:admin) { create(:admin) }

  before do
    sign_in :admin, admin
  end

  it 'renders the index' do
    get :index

    expect(response).to render_template :index
  end
end
