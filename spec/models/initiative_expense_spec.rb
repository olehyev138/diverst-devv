require 'rails_helper'

RSpec.describe InitiativeExpense, type: :model do
  describe 'when validating' do
    let(:initiative_expense) { build_stubbed(:initiative_expense) }

    it { expect(initiative_expense).to belong_to(:initiative) }
    it { expect(initiative_expense).to belong_to(:owner).class_name('User') }
    it { expect(initiative_expense).to validate_presence_of(:initiative) }
    it { expect(initiative_expense).to validate_presence_of(:owner) }
    it { expect(initiative_expense).to validate_presence_of(:amount) }
    it { expect(initiative_expense).to validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
  end


  describe 'validate against negative expenses on create' do
    let(:enterprise) { create(:enterprise) }
    let(:group) { create(:group, enterprise_id: enterprise.id, annual_budget: 10000) }
    let(:annual_budget) { create(:annual_budget, amount: group.annual_budget) }
    let(:initiative) { create(:initiative, owner_group_id: group.id, annual_budget_id: annual_budget.id) }
    let(:expense) { build(:initiative_expense, initiative_id: initiative.id, amount: initiative.estimated_funding + 200, annual_budget_id: annual_budget.id) }

    it '#prevent_creating_negative_expenses' do
      expect(expense).to receive(:prevent_creating_negative_expenses)
      expense.save
    end
  end

  describe 'test after_save and after_destroy callbacks' do
    let(:enterprise) { create(:enterprise) }
    let(:group) { create(:group, enterprise_id: enterprise.id, annual_budget: 10000) }
    let(:annual_budget) { create(:annual_budget, amount: group.annual_budget) }
    let(:initiative) { create(:initiative, owner_group_id: group.id, annual_budget_id: annual_budget.id) }
    let(:expense) { build(:initiative_expense, initiative_id: initiative.id, amount: initiative.estimated_funding + 200, annual_budget_id: annual_budget.id) }

    it 'after_save, #update_annual_budget' do
      expect(expense).to receive(:update_annual_budget)
      expense.run_callbacks(:save)
    end

    it 'after_destroy, #update_annual_budget' do
      expense.save
      expect(expense).to receive(:update_annual_budget)
      expense.run_callbacks(:destroy)
    end
  end
end
