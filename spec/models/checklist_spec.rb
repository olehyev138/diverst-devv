require 'rails_helper'

RSpec.describe Checklist, type: :model do
  let(:checklist) { build_stubbed(:checklist) }

  describe 'associations' do
    it { expect(checklist).to belong_to(:budget) }
    it { expect(checklist).to belong_to(:initiative) }
    it { expect(checklist).to belong_to(:author).class_name('User') }

    it { expect(checklist).to have_many(:items).class_name('ChecklistItem').dependent(:destroy) }
  end

  describe 'validations' do
    it { expect(checklist).to validate_length_of(:title).is_at_most(191) }
  end

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      checklist = create(:checklist)
      checklist_item = create(:checklist_item, checklist: checklist)

      checklist.destroy

      expect { Checklist.find(checklist.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { ChecklistItem.find(checklist_item.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
