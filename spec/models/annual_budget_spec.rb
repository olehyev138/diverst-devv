require 'rails_helper'

RSpec.describe AnnualBudget, type: :model do
  let(:annual_budget) { build(:annual_budget) }

  describe 'associations' do
    it { expect(annual_budget).to belong_to(:group) }
    it { expect(annual_budget).to have_one(:enterprise) }
    it { expect(annual_budget).to have_many(:initiatives).through(:group) }
    it { expect(annual_budget).to have_many(:budgets) }
    it { expect(annual_budget).to have_many(:initiative_expenses).through(:initiatives) }

    describe '#available' do
      let!(:enterprise) { create(:enterprise) }
      let!(:group) { create(:group, enterprise: enterprise, annual_budget: 2000) }
      let!(:annual_budget) { create(:annual_budget, group: group, enterprise: enterprise, amount: group.annual_budget) }
      let!(:budget) { create(:approved, annual_budget: annual_budget, group: group) }
      let!(:selected_budget) { budget.budget_items.first }
      let!(:initiative) { create(:initiative, :with_budget_item, owner_group: group, estimated_funding: selected_budget.available_amount,
                                                                 budget_item_id: selected_budget.id)
      }
      let!(:expense) { create(:initiative_expense, initiative: initiative, amount: 10) }

      it 'returns available which is the same as available' do
        annual_budget.reload
        expect(annual_budget.available).not_to eq nil
        expect(annual_budget.available).to eq annual_budget.available
      end
    end
  end
end
