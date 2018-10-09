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
end
