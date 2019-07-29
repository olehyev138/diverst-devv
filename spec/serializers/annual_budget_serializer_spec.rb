require 'rails_helper'

RSpec.describe AnnualBudgetSerializer, type: :serializer do
  it 'returns all fields' do
    enterprise = create(:enterprise)
    group = create(:group, enterprise: enterprise)
    annual_budget = create(:annual_budget, enterprise: enterprise, group: group)
    serializer = AnnualBudgetSerializer.new(annual_budget)

    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:group_id]).to_not be nil
    expect(serializer.serializable_hash[:enterprise]).to_not be nil
    expect(serializer.serializable_hash[:group]).to_not be nil
  end
end
