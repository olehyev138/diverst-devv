require 'rails_helper'

RSpec.describe BudgetItem, type: :model do
  describe 'factory' do
    let(:budget_item) { build_stubbed(:budget_item) }

    it 'is valid' do
      expect(budget_item).to be_valid
    end

    it { expect(budget_item).to validate_presence_of(:title) }
    it { expect(budget_item).to validate_length_of(:title).is_at_least(2).is_at_most(191) }
    it { expect(budget_item).to validate_numericality_of(:estimated_amount)
       .is_less_than_or_equal_to(999999).with_message('number of digits must not exceed 6')
    }
    it { expect(budget_item).to validate_numericality_of(:available_amount)
    }

    describe 'when validating' do
      it { expect(budget_item).to belong_to(:budget) }
      it { expect(budget_item).to have_many(:initiatives) }
    end

    describe 'test scopes' do
      before { build(:budget_item, is_done: false) }

      it 'return available budget items' do
        expect(BudgetItem.available.count).to eq 3
      end

      it 'return allocated budget items' do
        BudgetItem.last.update(is_done: true)
        expect(BudgetItem.allocated.count).to eq 1
      end
    end

    describe 'test instance_methods' do
      it '#title_with_amount' do
        bi = build(:budget_item, title: 'budget item one')
        expect(bi.title).to eq 'budget item one'
      end

      context '#available_amount' do
        it 'returns 0' do
          bi = build(:budget_item, is_done: true)
          expect(bi.available_amount).to eq 0
        end

        it 'return value' do
          bi = build(:budget_item)
          expect(bi.available_amount).not_to eq 0
        end
      end

      it '#approve!' do
        bi = build(:budget_item)
        bi.approve!
        expect(bi.available_amount).to eq bi.estimated_amount
      end
    end
  end
end
