require 'rails_helper'

RSpec.describe InitiativeUpdate, type: :model do
  it_behaves_like 'it Contains Field Data'

  describe 'test associations' do
    let!(:initiative_update) { build_stubbed(:initiative_update) }

    it { expect(initiative_update).to belong_to(:owner).class_name('User') }
    it { expect(initiative_update).to belong_to(:initiative) }
  end

  describe 'test instance methods' do
    let!(:initiative) { build(:initiative) }
    let!(:update) { build(:initiative_update, initiative_id: initiative.id, created_at: DateTime.now) }
    let!(:previous_update) { create(:initiative_update, initiative_id: initiative.id, created_at: DateTime.now - 2.hours) }
    let!(:next_update) { create(:initiative_update, initiative_id: initiative.id, created_at: DateTime.now + 2.hours) }

    context '#next' do
      it 'return the next update in chronological order' do
        expect(update.next).to eq next_update
      end
    end

    context '#previous' do
      it 'return the previous update in chronological order' do
        expect(update.previous).to eq previous_update
      end
    end
  end
end
