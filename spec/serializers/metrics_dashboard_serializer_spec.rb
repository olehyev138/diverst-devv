require 'rails_helper'

RSpec.describe MetricsDashboardSerializer, type: :serializer do
  it 'returns metrics dashboard' do
    metrics_dashboard = create(:metrics_dashboard)
    serializer = MetricsDashboardSerializer.new(metrics_dashboard, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(metrics_dashboard.id)
    expect(serializer.serializable_hash[:name]).to eq(metrics_dashboard.name)
  end
end
