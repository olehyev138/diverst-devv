require 'rails_helper'

RSpec.describe GraphSerializer, type: :serializer do
  let(:graph) { create(:graph) }
  let(:serializer) { GraphSerializer.new(graph, scope: serializer_scopes(create(:user))) }

  include_examples 'permission container', :serializer

  it 'returns graph' do
    expect(serializer.serializable_hash[:id]).to eq graph.id
    expect(serializer.serializable_hash[:metrics_dashboard_id]).to eq graph.metrics_dashboard_id
  end
end
