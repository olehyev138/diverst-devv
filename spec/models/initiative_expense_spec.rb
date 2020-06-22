require 'rails_helper'

RSpec.describe InitiativeExpense, type: :model do
  describe 'tests associations and validations' do
    let(:initiative_expense) { build_stubbed(:initiative_expense) }

    it { expect(initiative_expense).to belong_to(:initiative) }
    it { expect(initiative_expense).to belong_to(:owner).class_name('User') }
    it { expect(initiative_expense).to have_one(:annual_budget) }
    it { expect(initiative_expense).to have_one(:group).through(:annual_budget) }
    it { expect(initiative_expense).to have_one(:enterprise).through(:group) }
    it { expect(initiative_expense).to validate_presence_of(:initiative) }
    it { expect(initiative_expense).to validate_presence_of(:owner) }
    it { expect(initiative_expense).to validate_presence_of(:amount) }
    it { expect(initiative_expense).to validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
    it { expect(initiative_expense).to validate_length_of(:description).is_at_most(191) }
  end

  describe 'test scopes' do
    context 'initiative_expense::finalized' do
      let!(:budget) { create(:approved_budget, annual_budget: (create :annual_budget)) }
      let!(:annual_budget_initiative) { create :initiative, budget_item: budget.budget_items.first}
      let!(:finalized_initiative_expense) { create(:initiative_expense, initiative: annual_budget_initiative) }
      before do
        annual_budget_initiative.update(finished_expenses: true)
      end
      it 'returns initiative expense finalized' do
        expect(InitiativeExpense.finalized).to eq([finalized_initiative_expense])
      end
    end

    context 'initiative_expense::active' do
      let!(:budget) { create(:approved_budget, annual_budget: (create :annual_budget)) }
      let!(:annual_budget_initiative) { create :initiative, budget_item: budget.budget_items.first}
      let!(:active_initiative_expense) { create(:initiative_expense, initiative: annual_budget_initiative) }

      it 'returns initiative expense active' do
        expect(InitiativeExpense.active).to eq([active_initiative_expense])
      end
    end
  end

  describe 'test after_save and after_destroy callbacks' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group1) { create(:group, enterprise_id: enterprise.id, annual_budget: 10000) }
    let!(:annual_budget1) { create(:annual_budget, amount: group1.annual_budget, group_id: group1.id) }
    let!(:budget) { create(:approved_budget, group: group1, annual_budget_id: annual_budget1.id) }
    let!(:outcome) { create :outcome, group_id: group1.id }
    let!(:pillar) { create :pillar, outcome_id: outcome.id }
    let!(:initiative) { create(:initiative, owner_group_id: group1.id, pillar: pillar,
                                            estimated_funding: budget.budget_items.first.available_amount, budget_item_id: budget.budget_items.first.id)
    }
    let!(:expense) { create(:initiative_expense, initiative_id: initiative.id, amount: 10) }

    it 'sets expenses on annual_budget to 0 when expense is destroyed' do
      expense.reload
      annual_budget1.reload
      expect(annual_budget1.expenses).to eq expense.amount

      expense.destroy

      expect(annual_budget1.reload.expenses).to eq 0
    end
  end

  describe 'test after_save and after_destroy callbacks' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group1) { create(:group, :with_annual_budget, enterprise_id: enterprise.id, amount: 10000) }
    let!(:annual_budget1) { group1.current_annual_budget }
    let!(:budget) { create(:approved_budget, annual_budget_id: annual_budget1.id) }
    let!(:outcome) { create :outcome, group_id: group1.id }
    let!(:pillar) { create :pillar, outcome_id: outcome.id }
    let!(:initiative) { create(:initiative, owner_group_id: group1.id, pillar: pillar,
                                            estimated_funding: budget.budget_items.first.available_amount,
                                            budget_item_id: budget.budget_items.first.id)
    }
    let!(:expense) { create(:initiative_expense, initiative_id: initiative.id, amount: 10) }

    it 'sets expenses on annual_budget to 0 when expense is destroyed' do
      expense.reload
      annual_budget1.reload
      expect(annual_budget1.expenses).to eq expense.amount

      expense.destroy

      expect(annual_budget1.reload.expenses).to eq 0
    end
  end
end
