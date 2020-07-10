require 'rails_helper'

RSpec.describe GroupWithBudgetSerializer, type: :serializer do
  it 'returns Group With Budget' do
    enterprise = create(:enterprise)
    group = create(:group, enterprise: enterprise)
    annual_budget = create(:annual_budget, enterprise: enterprise, group: group)

    serializer = GroupWithBudgetSerializer.new(group, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to eq(group.id)
    expect(serializer.serializable_hash[:name]).to eq(group.name)
    expect(serializer.serializable_hash[:annual_budget]).to eq(group.annual_budget)
    expect(serializer.serializable_hash[:currency]).to eq(group.annual_budget_currency)
  end
end
