require 'rails_helper'

RSpec.describe ChecklistItem, type: :model do
  let(:checklist_item) { build(:checklist_item) }

  describe 'associations' do
    it { expect(checklist_item).to belong_to(:initiative) }
    it { expect(checklist_item).to belong_to(:checklist) }
  end

  describe 'validations' do
    it { expect(checklist_item).to validate_length_of(:title).is_at_most(191) }
  end
end
