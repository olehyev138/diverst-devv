require 'rails_helper'

RSpec.describe InitiativeUpdate, type: :model do
  it_behaves_like 'it Contains Field Data'

  describe 'test associations and validations' do
    let!(:initiative_update) { build_stubbed(:initiative_update) }

    it { expect(initiative_update).to belong_to(:owner).class_name('User') }
    it { expect(initiative_update).to belong_to(:updatable) }

    it { expect(initiative_update).to validate_length_of(:comments).is_at_most(65535) }
    it { expect(initiative_update).to validate_length_of(:data).is_at_most(65535) }
  end

  describe 'test instance methods' do
    let!(:initiative) { build(:initiative) }
    let!(:update) { create(:initiative_update, updatable: initiative, report_date: DateTime.now) }
    let!(:previous_update) { create(:initiative_update, updatable: initiative, report_date: DateTime.now - 2.days) }
    let!(:next_update) { create(:initiative_update, updatable: initiative, report_date: DateTime.now + 2.days) }

    context '#next' do
      it 'return the next update in chronological order' do
        expect(update.reload.next).to eq next_update
      end
    end

    context '#previous' do
      it 'return the previous update in chronological order' do
        expect(update.reload.previous).to eq previous_update
      end
    end

    context 'reported_for_date' do
      it 'returns report_date' do
        expect(update.reported_for_date).to eq update.report_date
      end

      it 'returns created_at' do
        update.update(report_date: nil)
        expect(update.reported_for_date).to eq update.created_at
      end
    end
  end
end
