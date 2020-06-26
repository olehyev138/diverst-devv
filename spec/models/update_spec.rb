require 'rails_helper'

RSpec.describe Update, type: :model do
  it_behaves_like 'it Contains Field Data'

  describe 'test associations and validation' do
    let!(:update) { build_stubbed(:group_update2) }

    it {validate_uniqueness_of expect(update).to belong_to(:owner).class_name('User') }
    it { expect(update).to belong_to(:updatable) }
    it { expect(update).to belong_to(:previous).class_name('Update').inverse_of(:next)  }

    context 'initiative' do
      let!(:initiative_update) { build(:initiative_update2, updatable_type: 'Initiative') }
      it { expect(initiative_update).to belong_to(:initiative).with_foreign_key(:updatable_id) }
    end

    context 'group' do
      let!(:group_update) { build(:group_update2, updatable_type: 'Group') }
      it { expect(group_update).to belong_to(:group).with_foreign_key(:updatable_id) }
    end

    it { expect(update).to have_one(:next).class_name('Update').with_foreign_key(:previous_id) .inverse_of(:previous) }
    it { expect(update).to accept_nested_attributes_for(:field_data) }

    it { expect(update).to validate_length_of(:comments).is_at_most(65535) }
    it { expect(update).to validate_length_of(:data).is_at_most(65535) }
    it { expect(update).to validate_presence_of(:report_date) }
    it { expect(update).to validate_presence_of(:updatable) }

    context 'uniqueness' do
      let!(:uniqueness_update) { create(:update) }
      it { expect(uniqueness_update).to validate_uniqueness_of(:report_date).scoped_to(:updatable_id) }
    end
  end

  describe 'test instance methods' do
    before do
      group = build(:group)
      @update = create(:update, updatable: group, report_date: DateTime.now)
      @previous_update = create(:update, updatable: group, report_date: DateTime.now - 2.days)
      @next_update = create(:update, updatable: group, report_date: DateTime.now + 2.days)
    end

    context '#next' do
      it 'return the next update in chronological order' do
        @update.reload
        expect(@update.next).to eq @next_update
      end
    end

    context '#previous' do
      it 'return the previous update in chronological order' do
        @update.reload
        expect(@update.previous).to eq @previous_update
      end
    end
  end
end
