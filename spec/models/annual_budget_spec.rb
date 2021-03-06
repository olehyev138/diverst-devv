require 'rails_helper'

RSpec.describe AnnualBudget, type: :model do
  let(:annual_budget) { build(:annual_budget) }

  describe 'associations' do
    it { expect(annual_budget).to belong_to(:group) }
    it { expect(annual_budget).to belong_to(:enterprise) }
    it { expect(annual_budget).to have_many(:initiatives) }
    it { expect(annual_budget).to have_many(:budgets) }
    it { expect(annual_budget).to have_many(:initiative_expenses) }

    describe '#approved_budget_leftover' do
      let!(:enterprise) { create(:enterprise) }
      let!(:group) { create(:group, enterprise: enterprise, annual_budget: 2000) }
      let!(:annual_budget) { create(:annual_budget, group: group, enterprise: enterprise, amount: group.annual_budget) }
      let!(:budget) { create(:approved_budget, annual_budget: annual_budget, group: group) }
      let!(:selected_budget) { budget.budget_items.first }
      let!(:initiative) { create(:initiative, owner_group: group, annual_budget: annual_budget, estimated_funding: selected_budget.available_amount,
                                              budget_item_id: selected_budget.id)
      }
      let!(:expense) { create(:initiative_expense, initiative: initiative, amount: 10, annual_budget: annual_budget) }

      it 'returns approved_budget_leftover which is the same as available_budget' do
        annual_budget.reload
        expect(annual_budget.approved_budget_leftover).not_to eq nil
        expect(annual_budget.approved_budget_leftover).to eq annual_budget.available_budget
      end
    end
  end
end
