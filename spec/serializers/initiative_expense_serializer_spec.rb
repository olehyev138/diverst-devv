require 'rails_helper'

RSpec.describe InitiativeExpenseSerializer, type: :serializer do
  it 'returns associations' do
    group = create(:group, annual_budgets: create_list(:annual_budget, 1, amount: 1000))
    initiative = create(:initiative, :with_budget_item, owner_group_id: group.id)
    initiative_expense = create(:initiative_expense, budget_user: initiative.budget_users.first)

    serializer = InitiativeExpenseSerializer.new(initiative_expense.reload, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(initiative_expense.id)
    expect(serializer.serializable_hash[:owner]).to_not be nil
    expect(serializer.serializable_hash[:initiative]).to be nil
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end
