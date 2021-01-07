require 'rails_helper'

RSpec.describe AnnualBudget, type: :model do
  let(:annual_budget) { build(:annual_budget) }

  describe 'associations' do
    it { expect(annual_budget).to belong_to(:budget_head) }
    it { expect(annual_budget).to belong_to(:enterprise) }
    it { expect(annual_budget).to have_many(:budget_items).through(:budgets) }
    it { expect(annual_budget).to have_many(:budget_users).through(:budget_items) }
    it { expect(annual_budget).to have_many(:budgets).dependent(:destroy) }
    it { expect(annual_budget).to have_many(:initiative_expenses).through(:budget_users).source(:expenses) }

    describe '#available' do
      let!(:enterprise) { create(:enterprise) }
      let!(:group) { create(:group, :with_annual_budget, enterprise: enterprise, amount: 2000) }
      let!(:annual_budget) { create(:annual_budget, group: group, enterprise: enterprise, amount: group.annual_budget) }
      let!(:budget) { create(:approved_budget, annual_budget: annual_budget, group: group) }
      let!(:selected_budget) { budget.budget_items.first }
      let!(:initiative) { create(:initiative, :with_budget_item, owner_group: group, estimated_funding: selected_budget.available,
                                                                 budget_item_id: selected_budget.id)
      }
      let!(:expense) { create(:initiative_expense, budget_user: initiative.budget_users.first, amount: 10) }

      it 'returns available which is the same as available' do
        annual_budget.reload
        expect(annual_budget.available).not_to eq nil
        expect(annual_budget.available).to eq annual_budget.available
      end
    end
  end
end
