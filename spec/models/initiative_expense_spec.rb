require 'rails_helper'

RSpec.describe InitiativeExpense, type: :model do
  describe 'tests associations and validations' do
    let(:initiative_expense) { build_stubbed(:initiative_expense) }

    it { expect(initiative_expense).to belong_to(:initiative) }
    it { expect(initiative_expense).to belong_to(:owner).class_name('User') }
    it { expect(initiative_expense).to belong_to(:annual_budget) }
    it { expect(initiative_expense).to validate_presence_of(:initiative) }
    it { expect(initiative_expense).to validate_presence_of(:owner) }
    it { expect(initiative_expense).to validate_presence_of(:amount) }
    it { expect(initiative_expense).to validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
    it { expect(initiative_expense).to validate_length_of(:description).is_at_most(191) }
  end

  describe 'test after_save and after_destroy callbacks' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group1) { create(:group, enterprise_id: enterprise.id, annual_budget: 10000) }
    let!(:annual_budget1) { create(:annual_budget, amount: group1.annual_budget, group_id: group1.id, enterprise_id: enterprise.id) }
    let!(:budget) { create(:approved_budget, group: group1, annual_budget_id: annual_budget1.id) }
    let!(:outcome) { create :outcome, group_id: group1.id }
    let!(:pillar) { create :pillar, outcome_id: outcome.id }
    let!(:initiative) { create(:initiative, owner_group_id: group1.id, annual_budget_id: annual_budget1.id, pillar: pillar,
                                            estimated_funding: budget.budget_items.first.available_amount, budget_item_id: budget.budget_items.first.id)
    }
    let!(:expense) { create(:initiative_expense, initiative_id: initiative.id, amount: 10, annual_budget_id: annual_budget1.id) }

    it 'after_save, #update_annual_budget' do
      expect(expense).to receive(:update_annual_budget)
      expense.run_callbacks(:save)
    end

    it 'after_destroy, #update_annual_budget' do
      expect(expense).to receive(:update_annual_budget)
      expense.run_callbacks(:destroy)
    end

    it 'sets expenses on annual_budget to 0 when expense is destroyed' do
      expense.reload
      annual_budget1.reload
      expect(annual_budget1.expenses).to eq expense.amount

      expense.destroy

      expect(annual_budget1.reload.expenses).to eq 0
    end
  end
end
