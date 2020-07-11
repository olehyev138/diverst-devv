require 'rails_helper'

RSpec.describe GraphSerializer, type: :serializer do
  it 'returns graph' do
    graph = create(:graph)
    serializer = GraphSerializer.new(graph, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to eq graph.id
    expect(serializer.serializable_hash[:metrics_dashboard_id]).to eq graph.metrics_dashboard_id
  end
end
