require 'rails_helper'

RSpec.describe Segmentation, type: :model do
    
    describe 'when validating' do
        let(:segmentation){ build_stubbed(:segmentation) }

        it{ expect(segmentation).to belong_to(:parent).class_name("Segment") }
        it{ expect(segmentation).to belong_to(:child).class_name("Segment") }
    end
end
