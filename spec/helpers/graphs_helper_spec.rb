require 'rails_helper'

RSpec.describe GraphsHelper do
  let!(:enterprise) { create(:enterprise) }
  let!(:aggregation) { create(:checkbox_field, title: 'Certifications', enterprise: enterprise) }
  let!(:metrics_dashboard) { create(:metrics_dashboard, enterprise: enterprise) }
  let!(:graph) { create(:graph, aggregation: aggregation, metrics_dashboard: metrics_dashboard) }

  describe '#aggregation_text' do
    it 'returns text if metrics_dashboard is present for graph' do
      expect(aggregation_text(graph)).to eq "Aggregated by #{graph.aggregation.title.downcase}"
    end

    it 'returns text if poll is present for graph' do
      poll = create(:poll, enterprise: enterprise)
      graph.update(poll_id: poll.id, metrics_dashboard_id: nil)


      expect(aggregation_text(graph)).to eq "Aggregated by answer to \"#{graph.aggregation.title}\""
    end
  end
end
