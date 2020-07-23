require 'rails_helper'

RSpec.describe MetricsDashboardSerializer, type: :serializer do
  let(:metrics_dashboard) { create(:metrics_dashboard) }
  let(:serializer) { MetricsDashboardSerializer.new(metrics_dashboard, scope: serializer_scopes(create(:user))) }

  include_examples 'permission container', :serializer

  it 'returns metrics dashboard' do
    expect(serializer.serializable_hash[:id]).to eq(metrics_dashboard.id)
    expect(serializer.serializable_hash[:name]).to eq(metrics_dashboard.name)
  end
end
