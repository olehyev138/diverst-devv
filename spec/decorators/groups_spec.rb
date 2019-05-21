require 'rails_helper'

RSpec.describe AnnualBudgetDecorator do

    let(:user) {create(:user)}
    let(:group){ create(:group, enterprise: user.enterprise) }
    let(:annual_budget) { create(:annual_budget, group_id: group.id) }
    let!(:budget){ create(:budget, group: group, is_approved: true, annual_budget_id: annual_budget.id) }

    describe "#spendings_percentage" do
        it "returns 0" do
            decorated_annual_budget = annual_budget.decorate
            expect(decorated_annual_budget.spendings_percentage).to eq(0)
        end

        it "returns 100"  do
            outcome = create(:outcome, :group => group)
            pillar = create(:pillar, :outcome => outcome)
            initiative = create(:initiative, :pillar => pillar, owner_group: group, annual_budget_id: annual_budget.id)
            create(:initiative_expense, :initiative => initiative, :amount => 100, annual_budget_id: annual_budget.id)
            annual_budget.update(amount: 100, expenses: group.spent_budget)    

            decorated_annual_budget = annual_budget.decorate
            expect(decorated_annual_budget.spendings_percentage).to eq(100)
        end

        it "returns 80.0"do
            (1..4).each do
                outcome = create(:outcome, :group => group)
                pillar = create(:pillar, :outcome => outcome)
                initiative = create(:initiative, :pillar => pillar, owner_group: group, annual_budget_id: annual_budget.id)
                create_list(:initiative_expense, 2, :initiative => initiative, :amount => 10, annual_budget_id: annual_budget.id)
            end
            annual_budget.update(amount: 100, expenses: group.spent_budget)    
            
            budget.budget_items.each do |item|
                item.estimated_amount = 40
                item.save
            end
            annual_budget.amount = 100
            annual_budget.save

            decorated_annual_budget = annual_budget.decorate
            expect(decorated_annual_budget.spendings_percentage).to eq(80.0)
        end
    end
end