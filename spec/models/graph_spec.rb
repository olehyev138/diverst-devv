require 'rails_helper'

RSpec.describe Graph, type: :model do
    
    describe 'validations' do
        let(:graph) { FactoryGirl.build_stubbed(:graph) }

        it{ expect(graph).to validate_presence_of(:field) }
        it{ expect(graph).to validate_presence_of(:collection) }
        
        it { expect(graph).to belong_to(:field) }
        it { expect(graph).to belong_to(:collection) }
        it { expect(graph).to belong_to(:aggregation) }
    end
end
