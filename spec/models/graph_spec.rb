require 'rails_helper'

RSpec.describe Graph, type: :model do

    describe 'validations' do
        let(:graph) { FactoryGirl.build_stubbed(:graph) }

        it{ expect(graph).to validate_presence_of(:field) }

        it { expect(graph).to belong_to(:field) }
        it { expect(graph).to belong_to(:metrics_dashboard) }
        it { expect(graph).to belong_to(:poll) }
        it { expect(graph).to belong_to(:aggregation) }
    end

    describe 'data' do
      let(:graph) { FactoryGirl.build_stubbed(:graph) }

      it 'builds query correctly with single aggregation on field' do
      end

      it 'builds query correctly with nested aggregation on fields' do
      end

      it 'builds query correctly with single aggregation on association' do

      end

      it 'builds query correctly with nested aggregation on association and field' do

      end
    end
end
