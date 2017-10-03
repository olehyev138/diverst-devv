require 'rails_helper'

RSpec.describe Resource, :type => :model do
    
    describe 'when validating' do
        let(:resource){ build_stubbed(:resource) }
        
        it{ expect(resource).to validate_presence_of(:title)}
    end
    
    
    
    describe '#extension' do
        it "returns the file's lowercase extension without the dot" do
            resource = build(:resource)
            expect(resource.file_extension).to eq 'csv'
        end
    end
end
