require 'rails_helper'

RSpec.describe BaseGraph do
  let(:dummy_class) { Class.new { include BaseGraph } }

  describe 'GraphBuilder' do
  end

  describe 'Nvd3Formatter' do
    let(:formatter) { BaseGraph::Nvd3Formatter.new }

    describe 'initialize' do
      describe 'parser' do
      end

      it 'has a default title of "Default Graph"' do
        expect(formatter.title).to eq 'Default Graph'
      end

      it 'has a default type of "bar"' do
        expect(formatter.type).to eq 'bar'
      end
    end

    describe 'format' do
      it 'returns a hash' do
        expect(formatter.format.class).to eq Hash
      end

      it 'allows title to be set' do
        formatter.title = 'Dummy Graph'

        expect(formatter.format[:title]).to eq 'Dummy Graph'
      end

      it 'allows type to be set' do
        formatter.type = 'line'

        expect(formatter.format[:type]).to eq 'line'
      end

      it 'allows x_label to be set' do
        formatter.x_label = 'dummy_x'

        expect(formatter.format[:x_label]).to eq 'dummy_x'
      end

      it 'allows y_label to be set' do
        formatter.y_label = 'dummy_y'

        expect(formatter.format[:y_label]).to eq 'dummy_y'
      end

      it 'removes 0 values' do
        formatter.add_elements([{ key: 0, doc_count: 0 }])

        expect(formatter.format[:series][0][:values].length).to eq 0
      end
    end

    describe 'add_series' do
      it 'uses set title as default name for series' do
        formatter.title = 'Dummy Title'
        formatter.add_series

        expect(formatter.format[:series][0][:key]).to eq 'Dummy Title'
      end

      it 'uses series_name argument as series name' do
        formatter.add_series(series_name: 'series_name')

        expect(formatter.format[:series][0][:key]).to eq 'series_name'
      end

      it 'adds multiple series' do
        formatter.add_series(series_name: 'series01')
        formatter.add_series(series_name: 'series02')

        expect(formatter.format[:series][1][:key]).to eq 'series02'
      end

      it 'uses valid series structure' do
        formatter.add_series(series_name: 'series01')
        formatter.add_series(series_name: 'series02')

        expect(formatter.format[:series][1][:values].class).to eq Array
      end

      it 'doesnt add a duplicate series' do
        formatter.add_series(series_name: 'series01')
        formatter.add_series(series_name: 'series01')

        expect(formatter.format[:series].count).to eq 1
      end
    end

    describe 'add_element' do
      let(:default_es_element) { { key: 'element01', doc_count: 9 } }
      let(:children) { [ { key: 'child01', doc_count: 3 }, { key: 'child02', doc_count: 7 } ] }

      it 'adds a default elasticsearch element' do
        formatter.add_element(default_es_element)

        expect(formatter.format[:series][0][:values][0][:x]).to eq 'element01'
        expect(formatter.format[:series][0][:values][0][:y]).to eq 9
      end

      it 'adds a default series using title when none exist' do
        formatter.title = 'dummy title'
        formatter.add_element(default_es_element)

        expect(formatter.format[:series][0][:key]).to eq 'dummy title'
      end

      it 'adds a element to specified series' do
        formatter.add_series(series_name: 'series01')
        formatter.add_series(series_name: 'series02')
        formatter.add_element(default_es_element, series_key: 'series01')

        expect(formatter.format[:series][0][:values][0][:x]).to eq 'element01'
        expect(formatter.format[:series][1][:values]).to eq []
      end

      it 'adds a element to most recently added series when none specified' do
        formatter.add_series(series_name: 'series01')
        formatter.add_series(series_name: 'series02')
        formatter.add_element(default_es_element)

        expect(formatter.format[:series][1][:values][0][:x]).to eq 'element01'
        expect(formatter.format[:series][0][:values]).to eq []
      end

      it 'adds a element with children' do
        formatter.add_element(default_es_element, children: children)

        expect(formatter.format[:series][0][:values][0][:children][:values].count).to eq 2
      end

      it 'uses default key for children series when none specified' do
        formatter.add_element(default_es_element, children: children)

        expect(formatter.format[:series][0][:values][0][:children][:key]).to eq 'element01'
      end

      it 'uses specified key for children series' do
        formatter.add_element(default_es_element, element_key: 'dummy key', children: children)

        expect(formatter.format[:series][0][:values][0][:children][:key]).to eq 'dummy key'
      end
    end
  end

  describe 'ElasticsearchParser' do
    let(:parser) { BaseGraph::ElasticsearchParser.new }

    it 'parses with defaults' do
      expect(parser.parse({ key: :value })[:x]).to eq :value
    end

    describe 'extractors' do
      describe 'date range' do
        let(:date_range_proc) { parser.date_range(key: :key) }
        let(:element) { double('element') }

        it 'parses a date range agg response' do
          allow(element).to receive_message_chain(:agg, :buckets) { [{ key: 'key' }] }

          expect(date_range_proc.call(element, {})).to eq('key')
        end

        it 'yields to block & runs returned lambda' do
          expect(
            (parser.date_range() { |_| -> (e, _) { 'dummy' } }).call(element, {})
          ).to eq 'dummy'
        end

        it 'returns 0 when element is nil' do
          expect(date_range_proc.call(element, {})).to eq 0
        end
      end

      describe 'top hits' do
        let(:top_hits_proc) { parser.top_hits(key: :key) }
        let(:element) { double('element') }

        it 'parses a top hits agg response' do
          allow(element).to receive_message_chain(:agg, :hits, :hits) { [{ '_source' => { key: 'key' } }] }

          expect(top_hits_proc.call(element, {})).to eq('key')
        end

        it 'returns 0 when element is nil' do
          expect(top_hits_proc.call(element, {})).to eq 0
        end
      end
    end
  end
end
