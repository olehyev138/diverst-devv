require 'rails_helper'

RSpec.describe Outcome, type: :model do
    
    describe 'when validating' do
        let(:outcome) { build_stubbed(:outcome) }
        
        it { expect(outcome).to belong_to(:group) }
        
        it { expect(outcome).to have_many(:pillars) }
    end
    
    describe 'default_scope' do
        let(:outcome) { create(:outcome) }
            
        it "gets the outcome" do    
            expect(Outcome.all).to eq [outcome]
        end
    end
end
