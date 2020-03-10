require 'rails_helper'

RSpec.describe BudgetItem, type: :model do
  describe 'factory' do
    let(:budget_item) { build(:budget_item) }

    it 'is valid' do
      expect(budget_item).to be_valid
    end

    it 'requires a title' do
      budget_item.title = nil
      expect(budget_item).to_not be_valid
      expect(budget_item.errors.full_messages.first).to eq("Title can't be blank")
    end

    it 'requires a title' do
      budget_item.title = 'o'
      expect(budget_item).to_not be_valid
      expect(budget_item.errors.full_messages.first).to eq('Title is too short (minimum is 2 characters)')
    end

    it 'requires estimated_amount to be a number' do
      budget_item.estimated_amount = 'o'
      expect(budget_item).to_not be_valid
      expect(budget_item.errors.full_messages.first).to eq('Estimated amount number of digits must not exceed 6')
    end

    it 'requires available_amount to be less_than_or_equal_to estimated_amount', skip: 'Available Amount Deprecated' do
      budget_item.estimated_amount = 1
      budget_item.available_amount = 2
      expect(budget_item).to_not be_valid
      expect(budget_item.errors.full_messages.first).to eq('Available amount must be less than or equal to 1.0')
    end

    describe 'when validating' do
      it { expect(budget_item).to belong_to(:budget) }
      it { expect(budget_item).to have_many(:initiatives) }
    end
  end

  describe 'validation' do
    let(:budget_item) { build(:budget_item) }

    describe 'available_amount' do
      before do
        budget_item.estimated_amount = 100
        budget_item.available_amount = 1000
      end

      it 'is invalid when greater than estimated_amount', skip: 'Available Amount Deprecated' do
        expect(budget_item).to_not be_valid
      end
    end
  end
end
