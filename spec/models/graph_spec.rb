require 'rails_helper'

RSpec.describe Graph, type: :model do

    describe 'validations' do
        let(:graph) { FactoryGirl.build_stubbed(:graph_with_metrics_dashboard) }

        it{ expect(graph).to validate_presence_of(:field) }

        it { expect(graph).to belong_to(:field) }
        it { expect(graph).to belong_to(:metrics_dashboard) }
        it { expect(graph).to belong_to(:poll) }
        it { expect(graph).to belong_to(:aggregation) }
    end

    describe 'build_query' do
      let!(:graph_model) { FactoryGirl.create(:graph_with_metrics_dashboard) }
      let(:graph_builder) { double(BaseGraph::GraphBuilder) }

      let(:date_range) { { from: 'now-200y/y', to: 'now-2d/d' } }

      before {
        allow(graph_builder).to receive(:get_new_query) { BaseSearch::ElasticsearchQuery.new }
        allow(graph_builder).to receive(:query=) { |q| q }

        graph_model.field = CheckboxField.new(id: 5)
      }

      describe 'top level bool filter' do
        it 'has a top level bool filter' do
          query = graph_model.send(:build_query, date_range).build

          expect(query.dig(:aggs, :agg, :filter)).to have_key(:bool)
        end

        it 'to have valid groups must_not clause' do
          graph_model.instance_variable_set(:@groups, ['group01'])

          query = graph_model.send(:build_query, date_range).build
          clause = query.dig(:aggs, :agg, :filter, :bool, :must_not, 0, 'terms')

          expect(clause).to have_key('group.name')
          expect(clause['group.name'][0]).to eq 'group01'
        end

        it 'to have valid segments must_not clause' do
          graph_model.instance_variable_set(:@segments, ['segment01'])

          query = graph_model.send(:build_query, date_range).build
          clause = query.dig(:aggs, :agg, :filter, :bool, :must_not, 1, 'terms')

          expect(clause).to have_key('segment.name')
          expect(clause['segment.name'][0]).to eq 'segment01'
        end
      end

      describe 'single terms query' do
        let(:query) { graph_model.send(:build_query, date_range).build }

        it 'has a valid terms agg with correct field' do
          terms = query.dig(:aggs, :agg, :aggs, :agg, :terms)

          expect(terms[:field]).to eq graph_model.field.elasticsearch_field
        end

        it 'has a valid terms agg with correct min_doc_count' do
          terms = query.dig(:aggs, :agg, :aggs, :agg, :terms)

          expect(terms[:min_doc_count]).to eq 1
        end

        it 'has a valid bottom level date range agg with correct field' do
          date_range = query.dig(:aggs, :agg, :aggs, :agg, :aggs, :agg, :date_range)

          expect(date_range[:field]).to eq 'user.created_at'
        end

        it 'has a valid bottom level date range agg with correct range' do
          date_range = query.dig(:aggs, :agg, :aggs, :agg, :aggs, :agg, :date_range)

          expect(date_range[:ranges][0][:from]).to eq 'now-200y/y'
        end
      end

      describe 'nested terms query' do
      end
    end

    describe 'get_custom_class' do
      let(:graph) { FactoryGirl.build_stubbed(:graph_with_metrics_dashboard) }
      let(:custom_class) { graph.send(:get_custom_class) }

      it 'custom class instance to be returned' do
        expect(custom_class).to_not eq nil
      end

      #it 'expect it to define #__elasticsearch__ and #search and pass correct arguments to elasticsearch'
    end
end
