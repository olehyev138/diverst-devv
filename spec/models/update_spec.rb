require 'rails_helper'

RSpec.describe Update, type: :model do
  it_behaves_like 'it Contains Field Data'

  describe 'test associations' do
    let!(:update) { build_stubbed(:group_update2) }

    it { expect(update).to belong_to(:owner).class_name('User') }
    it { expect(update).to belong_to(:updatable) }
  end

  describe 'test instance methods' do
    let!(:group) { build(:group) }
    let!(:update) { create(:update, updatable: group, report_date: DateTime.now) }
    let!(:previous_update) { create(:update, updatable: group, report_date: DateTime.now - 2.days) }
    let!(:next_update) { create(:update, updatable: group, report_date: DateTime.now + 2.days) }

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
