require 'rails_helper'

RSpec.describe AnnualBudgetSerializer, type: :serializer do
  it 'returns all fields' do
    enterprise = create(:enterprise)
    group = create(:group, enterprise: enterprise)
    annual_budget = create(:annual_budget, enterprise: enterprise, group: group)
    serializer = AnnualBudgetSerializer.new(annual_budget, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:group_id]).to_not be nil
    expect(serializer.serializable_hash[:enterprise]).to be nil
    expect(serializer.serializable_hash[:group]).to be nil
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end
