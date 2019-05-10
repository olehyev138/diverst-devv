require 'rails_helper'

RSpec.describe BaseSearch do
  # TODO figure out what directory this goes in

  let(:dummy_class) { Class.new { include BaseSearch } }

  describe 'ClassMethods' do
    it 'get_query returns an instance of ElasticsearchQuery' do
      expect(dummy_class.get_query.instance_of? BaseSearch::ElasticsearchQuery).to eq true
    end

    # TODO: test search

    #    describe 'search' do
    #      let(:dummy_group) { Group.new { include BaseSearch } }
    #
    #      it 'wraps query with an enterprise filter agg' do
    #        byebug
    #        query = nil
    #        allow_any_instance_of(Group).to receive_message_chain(:__elasticsearch__, :search) { |q| query = q }
    #      end
    #    end
  end

  describe 'ElasticsearchQuery' do
    let(:query) { dummy_class.get_query }

    describe 'build' do
      let (:built_query) { query.top_hits_agg.build }

      it 'returns a hash' do
        expect(built_query.class).to eq Hash
      end

      it 'returns hash with a size field' do
        expect(built_query).to have_key(:size)
      end

      it 'returns hash with a default size field' do
        expect(built_query[:size]).to eq 0
      end

      it 'returns hash with a root agg' do
        expect(built_query).to have_key(:aggs)
      end

      it 'returns a query with a valid aggregation' do
        expect(built_query[:aggs][:agg]).to have_key(:top_hits)
      end

      it 'creates a empty query when no aggregations specified' do
        empty_query = dummy_class.get_query.build

        expect(empty_query).to_not have_key(:aggs)
      end
    end

    describe 'base_agg' do
      it 'passes a new instance of ElasticsearchQuery to block' do
        passed_query = nil
        query.top_hits_agg { |q| (passed_query = q).top_hits_agg }

        expect(passed_query).to_not eq query
      end
    end

    describe 'filter agg' do
      let(:filter_agg) { query.filter_agg(field: 'dummy_field', value: 'dummy_value').build[:aggs][:agg] }

      it 'returns a valid filter agg' do
        expect(filter_agg[:filter][:term]).to have_key 'dummy_field'
      end

      it 'returns a valid filter agg with specified value' do
        expect(filter_agg[:filter][:term]['dummy_field']).to eq 'dummy_value'
      end

      it 'validly nests an aggregation' do
        nested_filter_agg = query
          .filter_agg(field: 'dummy_field', value: 'dummy_value') { |q| q.top_hits_agg }.build[:aggs][:agg]

        expect(nested_filter_agg[:aggs]).to have_key :agg
      end
    end

    describe 'bool filter agg' do
      let(:bool_agg) { query.bool_filter_agg.build[:aggs][:agg] }

      it 'returns a valid empty bool filter agg' do
        expect(bool_agg).to have_key :filter
      end

      it 'validly nests an aggregation' do
        nested_bool_agg = query
          .bool_filter_agg { |q| q.top_hits_agg }.build[:aggs][:agg]

        expect(nested_bool_agg[:aggs]).to have_key :agg
      end

      describe 'add filter clause' do
        before(:each) {
          @default_filter_agg = BaseSearch::ElasticsearchQuery.new
            .bool_filter_agg
            .add_filter_clause(field: 'dummy_field', value: 'dummy_value')
            .build[:aggs][:agg][:filter][:bool]

          @negative_filter_agg = BaseSearch::ElasticsearchQuery.new
            .bool_filter_agg
            .add_filter_clause(field: 'dummy_field', value: 'dummy_value', bool_op: :must_not)
            .build[:aggs][:agg][:filter][:bool]

          @multi_filter_agg = BaseSearch::ElasticsearchQuery.new
            .bool_filter_agg
            .add_filter_clause(field: 'dummy_field', value: ['dv01', 'dv02'], multi: true)
            .build[:aggs][:agg][:filter][:bool]
        }

        it 'returns if no bool query has been added to query object' do
          no_bool_query = BaseSearch::ElasticsearchQuery.new
          expect(no_bool_query.add_filter_clause(field: 'f', value: 'v')).to eq nil
        end

        it 'returns a valid default filter clause with specified field' do
          expect(@default_filter_agg[:must][0]['term']).to have_key 'dummy_field'
        end

        it 'returns a valid default filter clause with specified value' do
          expect(@default_filter_agg[:must][0]['term']['dummy_field']).to eq 'dummy_value'
        end

        it 'returns a valid filter clause using specified bool op' do
          expect(@negative_filter_agg[:must_not][0]['term']).to have_key 'dummy_field'
        end

        it 'returns a valid filter clause using multiple values' do
          expect(@multi_filter_agg[:must][0]['terms']['dummy_field'][1]).to eq 'dv02'
        end

        it 'adds multiple clauses of same bool type' do
          agg = BaseSearch::ElasticsearchQuery.new
            .bool_filter_agg
            .add_filter_clause(field: 'dummy_field01', value: 'dummy_value01')
            .add_filter_clause(field: 'dummy_field02', value: 'dummy_value02')
            .build[:aggs][:agg][:filter][:bool]

          expect(agg[:must].count).to eq 2
        end

        it 'adds multiple clauses of different bool type' do
          agg = BaseSearch::ElasticsearchQuery.new
            .bool_filter_agg
            .add_filter_clause(field: 'dummy_field01', value: 'dummy_value01', bool_op: :must_not)
            .add_filter_clause(field: 'dummy_field02', value: 'dummy_value02', bool_op: :should)
            .build[:aggs][:agg][:filter][:bool]

          expect(agg[:must_not].count).to eq 1
          expect(agg[:should].count).to eq 1
        end
      end
    end

    describe 'sum agg' do
    end

    describe 'date range agg' do
      let (:date_range) { { from: 'now-1y/y', to: 'now-3d/d' } }
      let(:date_range_agg) { query
          .date_range_agg(field: 'dummy_field', range: date_range)
          .build[:aggs][:agg]
      }

      it 'returns a valid date range agg with specified field' do
        expect(date_range_agg[:date_range][:field]).to eq 'dummy_field'
      end

      it 'returns a valid date range agg with specified date range' do
        expect(date_range_agg[:date_range][:ranges][0]).to eq date_range
      end

      it 'validly nests an aggregation' do
        nested_filter_agg = query
          .date_range_agg(field: 'dummy_field', range: date_range) { |q| q.top_hits_agg }.build[:aggs][:agg]

        expect(nested_filter_agg[:aggs]).to have_key :agg
      end
    end

    describe 'top hits agg' do
      let(:default_top_hits_agg) { query.top_hits_agg.build[:aggs][:agg] }
      let(:top_hits_agg) { query.top_hits_agg(size: 95).build[:aggs][:agg] }

      it 'returns a valid top hits agg with specified size' do
        expect(top_hits_agg[:top_hits][:size]).to eq 95
      end

      it 'returns a valid top hits agg with correct default size' do
        expect(default_top_hits_agg[:top_hits][:size]).to eq 100
      end

      it 'validly nests an aggregation' do
        nested_filter_agg = query
          .top_hits_agg { |q| q.top_hits_agg }.build[:aggs][:agg]

        expect(nested_filter_agg[:aggs]).to have_key :agg
      end
    end

    describe 'terms agg' do
      let(:default_terms_agg) { query
          .terms_agg(field: 'dummy_field')
          .build[:aggs][:agg]
      }

      let(:terms_agg) { query
          .terms_agg(field: 'dummy_field', order_field: '_key', order_dir: 'asc')
          .build[:aggs][:agg]
      }

      it 'returns a valid terms agg with specified field' do
        expect(terms_agg[:terms][:field]).to eq 'dummy_field'
      end

      it 'returns a valid terms agg with specified order field' do
        expect(terms_agg[:terms][:order]).to have_key '_key'
      end

      it 'returns a valid terms agg with specified order dir' do
        expect(terms_agg[:terms][:order]['_key']).to eq 'asc'
      end

      it 'returns a valid terms agg with default order field' do
        expect(default_terms_agg[:terms][:order]).to have_key '_count'
      end

      it 'returns a valid terms agg with default order dir' do
        expect(default_terms_agg[:terms][:order]['_count']).to eq 'desc'
      end

      it 'validly nests an aggregation' do
        nested_filter_agg = query
          .terms_agg(field: 'dummy_field') { |q| q.top_hits_agg }.build[:aggs][:agg]

        expect(nested_filter_agg[:aggs]).to have_key :agg
      end
    end

    describe 'agg' do
      let(:agg) { query.agg(type: 'missing', field: 'dummy_field').build[:aggs][:agg] }

      it 'returns a valid agg of specified type' do
        expect(agg).to have_key 'missing'
      end

      it 'returns a valid agg with the specified field' do
        expect(agg['missing'][:field]).to eq 'dummy_field'
      end

      it 'validly nests an aggregation' do
        nested_filter_agg = query
          .agg(type: 'dummy', field: 'dummy_field') { |q| q.top_hits_agg }.build[:aggs][:agg]

        expect(nested_filter_agg[:aggs]).to have_key :agg
      end
    end
  end
end
