require 'rails_helper'

RSpec.describe BudgetItem, type: :model do
  describe 'factory' do
    let(:budget_item) { FactoryGirl.build(:budget_item) }

    it 'is valid' do
      expect(budget_item).to be_valid
    end
  end

  describe 'validation' do
    let(:budget_item) { FactoryGirl.build(:budget_item) }

    describe 'available_amount' do
      before do
        budget_item.estimated_amount = 100
        budget_item.available_amount = 1000
      end

      it 'is invalid when greater than estimated_amount' do
        expect(budget_item).to_not be_valid
      end
    end
  end
end
