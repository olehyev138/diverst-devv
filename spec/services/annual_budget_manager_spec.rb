require 'rails_helper'

RSpec.describe AnnualBudgetManager, type: :service do
  let!(:enterprise) { create(:enterprise) }
  let!(:group) { create(:group, enterprise: enterprise, annual_budget: 10000) }
  let!(:annual_budget) { create(:annual_budget, group: group, amount: group.annual_budget, enterprise_id: enterprise.id) }


  describe '#reset!' do
    context 'when there are no initiatives for group' do
      it 'resets values of existing annual budget and group.annual_budget to 0' do
        expect(group.annual_budget).to eq 10000

        AnnualBudgetManager.new(group).reset!

        expect(group.annual_budget).to eq 0
        expect(annual_budget.reload.amount).to eq 0
      end
    end

    context 'when an initiative with estimated funding and expenses made exists' do
      let!(:budget) { create(:approved_budget, group_id: group.id, annual_budget_id: annual_budget.id) }
      let!(:initiative) { create(:initiative, owner_group: group, annual_budget_id: annual_budget.id, estimated_funding: budget.budget_items.first.available_amount,
                                              budget_item_id: budget.budget_items.first.id)
      }
      let!(:expense) { create(:initiative_expense, initiative_id: initiative.id, annual_budget_id: annual_budget.id, amount: 50) }

      it 'closes existing annual budget and opens a new annual budget' do
        expect(group.annual_budgets.count).to eq 1
        expect(group.annual_budgets.last.closed).to eq false

        AnnualBudgetManager.new(group).reset!

        expect(group.annual_budgets.count).to eq 2
        expect(group.annual_budgets.first.closed).to eq true
        expect(group.annual_budgets.last.closed).to eq false
      end
    end

    context 'when group.annual_budget is either 0 or nil' do
      let!(:group1) { create(:group, enterprise: enterprise) }

      it 'returns nil on reset' do
        expect(AnnualBudgetManager.new(group1).reset!).to eq nil
      end
    end
  end

  describe '#edit' do
    context 'when empty hash is passed' do
      it 'returns nil on edit' do
        expect(AnnualBudgetManager.new(group).edit({})).to eq nil
      end

      it 'does not update annual budget' do
        AnnualBudgetManager.new(group).edit({})

        expect(group.annual_budget).to eq 10000
        expect(group.annual_budgets.last.amount).to eq 10000
      end
    end

    context 'when annual_budget_params is passed' do
      annual_budget_params = { 'annual_budget' => 8000 }

      it 'updates annual_budget' do
        expect(group.annual_budget).to eq 10000
        expect(group.annual_budgets.last.amount).to eq 10000

        AnnualBudgetManager.new(group).edit(annual_budget_params)

        expect(group.annual_budget).to eq 8000
        expect(group.annual_budgets.last.amount).to eq 8000
      end
    end

    context 'when annual_budget_params is 0' do
      annual_budget_params = { 'annual_budget' => 0 }

      it 'returns nil on edit' do
        expect(AnnualBudgetManager.new(group).edit({})).to eq nil
      end

      it 'does not update annual budget' do
        AnnualBudgetManager.new(group).edit(annual_budget_params)

        expect(group.annual_budget).to eq 10000
        expect(group.annual_budgets.last.amount).to eq 10000
      end
    end
  end

  describe '#approve' do
    let!(:budget) { create(:approved_budget, group_id: group.id, annual_budget_id: annual_budget.id) }

    it 'sets approved_budget in annual_budget object' do
      expect(annual_budget.approved_budget).to eq 0

      AnnualBudgetManager.new(group).approve

      approved_budget = budget.budget_items.sum(:available_amount)
      expect(annual_budget.reload.approved_budget).to eq approved_budget
    end
  end

  describe '#carry_over!' do
    context 'when group.annual_budget is either 0 or nil' do
      let!(:group1) { create(:group, enterprise: enterprise) }

      it 'returns nil on reset' do
        expect(AnnualBudgetManager.new(group1).carry_over!).to eq nil
      end
    end

    context 'when existing annual_budget has leftover' do
      let!(:budget) { create(:approved_budget, group_id: group.id, annual_budget_id: annual_budget.id) }
      let!(:initiative) { create(:initiative, owner_group: group, annual_budget_id: annual_budget.id, estimated_funding: budget.budget_items.first.available_amount,
                                              budget_item_id: budget.budget_items.first.id)
      }
      let!(:expense) { create(:initiative_expense, initiative_id: initiative.id, annual_budget_id: annual_budget.id, amount: 50) }


      it 'carry over leftover in existing annual budget into new one' do
        annual_budget.reload
        initiative.finish_expenses!
        expect(group.leftover_money).not_to eq 0
        expect(group.annual_budgets.count).to eq 1
        expect(annual_budget.leftover_money).to eq group.leftover_money

        AnnualBudgetManager.new(group).carry_over!

        annual_budget.reload
        expect(group.annual_budgets.count).to eq 2
        expect(group.annual_budgets.last.amount).to eq group.annual_budgets.first.leftover_money
      end
    end
  end

  describe '#re_assign_annual_budget' do
    let!(:budget) { create(:approved_budget, group_id: group.id, annual_budget_id: annual_budget.id) }
    let!(:initiative) { create(:initiative, owner_group: group, annual_budget_id: annual_budget.id, estimated_funding: budget.budget_items.first.available_amount,
                                            budget_item_id: budget.budget_items.first.id)
    }
    let!(:expense) { create(:initiative_expense, initiative_id: initiative.id, annual_budget_id: annual_budget.id, amount: 50) }

    before do
      initiative.finish_expenses!
      AnnualBudgetManager.new(group).carry_over!
    end

    context 'when initiative annual_budget is not equal to annual_budget of selected budget_item' do
      # the second annual_budget is gotten from calling carry_over on AnnualBudgetManager
      let!(:annual_budget1) { group.annual_budgets.find_by(closed: false) }
      let!(:budget1) { create(:approved_budget, group_id: group.id, annual_budget_id: annual_budget1.id) }
      let!(:initiative1) { create(:initiative, owner_group: group, annual_budget_id: annual_budget.id, estimated_funding: budget1.budget_items.first.available_amount,
                                               budget_item_id: budget1.budget_items.first.id)
      }

      it 're-assign annual budget for initiative' do
        expect(initiative1.annual_budget).not_to eq budget1.annual_budget

        AnnualBudgetManager.new(group).re_assign_annual_budget(budget1.budget_items.first.id, initiative1.id)

        expect(initiative1.reload.annual_budget).to eq budget1.annual_budget
      end
    end
  end
end
