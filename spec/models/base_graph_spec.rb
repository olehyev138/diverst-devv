require 'rails_helper'

RSpec.describe BaseGraph do
  let(:dummy_class) { Class.new { include BaseGraph } }

  describe 'ElasticsearchParser' do
    let(:parser) { BaseGraph::ElasticsearchParser.new }

    it 'parses with defaults' do
      expect(parser.parse({key: :value})).to eq :value
    end

    it 'parses with specified key' do
      parser.key = :dummy

      expect(parser.parse({dummy: :value})).to eq :value
    end

    it 'parses with custom extractor, passing it the correct value and custom arguments hash' do
      parser.extractor = -> (e, args) { args[:dummy]  }

      expect(parser.parse({}, {dummy: :value})).to eq :value
    end

    describe 'parsers' do
      describe 'date range' do
        let(:date_range_proc) { parser.date_range }
        let(:element) { double('element') }

        it 'parses a date range agg response' do
          allow(element).to receive_message_chain(:agg, :buckets) { [{}] }

          expect(date_range_proc.call(element)).to eq({})
        end

        it 'yields to block & runs returned lambda' do
          expect(
            (parser.date_range() { |_| -> (e) { 'dummy' }  }).call(element)
          ).to eq 'dummy'
        end

        it 'returns 0 when element is nil' do
          expect(date_range_proc.call(element)).to eq 0
        end
      end

      describe 'top hits' do
        let(:top_hits_proc) { parser.top_hits }
        let(:element) { double('element') }

        it 'parses a top hits agg response' do
          allow(element).to receive_message_chain(:agg, :hits, :hits) { [{'_source' => {}}] }

          expect(top_hits_proc.call(element)).to eq({})
        end

        it 'returns 0 when element is nil' do
          expect(top_hits_proc.call(element)).to eq 0
        end
      end
    end
  end

  describe 'Nvd3Formatter' do
  end

  describe 'GraphBuilder' do
  end
end
