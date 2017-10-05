require 'rails_helper'

RSpec.describe Checklist, type: :model do
    describe 'validations' do
        let(:checklist) { FactoryGirl.build_stubbed(:checklist) }

        it { expect(checklist).to belong_to(:subject) }
        it { expect(checklist).to belong_to(:author) }
        
        it { expect(checklist).to have_many(:items) }
    end
end
