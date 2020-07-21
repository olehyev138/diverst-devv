require 'rails_helper'

RSpec.describe InitiativeExpenseSerializer, type: :serializer do
  it 'returns associations' do
    group = create(:group, annual_budget: 1000)
    initiative = create(:initiative, :with_budget_item, owner_group_id: group.id)
    initiative_expense = create(:initiative_expense, initiative: initiative)

    serializer = InitiativeExpenseSerializer.new(initiative_expense, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(initiative_expense.id)
    expect(serializer.serializable_hash[:owner]).to_not be nil
    expect(serializer.serializable_hash[:initiative]).to_not be nil
  end
end
