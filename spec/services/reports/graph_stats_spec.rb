require 'rails_helper'

RSpec.describe Reports::GraphStats, skip: 'Is this used anywhere?' do
  let(:graph_stats) { Reports::GraphStats.new(graph) }
  let!(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }
  let!(:poll) { create(:poll, enterprise: enterprise) }
  let!(:field) { SelectField.create!(attributes_for(:select_field, container: poll)) }
  let!(:aggregation) { SelectField.create!(attributes_for(:select_field, container: poll)) }
  let!(:poll_response) { create(:poll_response, user: user, poll: poll, data: { field.id.to_s => 'Yes' }.to_json) }

  context 'when there is an aggregate field' do
    let!(:graph) { create(:poll_graph, field: field, collection: poll) }

    it 'return the header of spreadsheet' do
    end

    it 'return the body of spreadsheet' do
    end
  end

  context 'when there is not an aggregate field' do
    let!(:graph) { create(:poll_graph, field: field, collection: poll, aggregation: aggregation) }

    it 'return the header of spreadsheet' do
    end

    it 'return the body of spreadsheet' do
    end
  end
end
