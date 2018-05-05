require 'rails_helper'

RSpec.describe Checklist, type: :model do
    describe 'validations' do
        let(:checklist) { FactoryGirl.build_stubbed(:checklist) }

        it { expect(checklist).to belong_to(:budget) }
        it { expect(checklist).to belong_to(:initiative) }
        it { expect(checklist).to belong_to(:author) }
        
        it { expect(checklist).to have_many(:items) }
    end
    
    describe "#destroy_callbacks" do
        it "removes the child objects" do
            checklist = create(:checklist)
            checklist_item = create(:checklist_item, :checklist => checklist)
            
            checklist.destroy
            
            expect{Checklist.find(checklist.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{ChecklistItem.find(checklist_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
        end
    end
end
