require 'rails_helper'

RSpec.describe BudgetItem, type: :model do
  describe 'factory' do
    let(:budget_item) { FactoryGirl.build(:budget_item) }

    it 'is valid' do
      byebug
      expect(budget_item).to be_valid
    end
  end
end
