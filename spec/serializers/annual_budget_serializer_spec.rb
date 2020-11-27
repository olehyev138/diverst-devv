require 'rails_helper'

RSpec.describe AnnualBudgetSerializer, type: :serializer do
  let(:enterprise) { create(:enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:annual_budget) { create(:annual_budget, enterprise: enterprise, group: group) }
  let(:serializer) { AnnualBudgetSerializer.new(annual_budget, scope: serializer_scopes(create(:user))) }

  it 'returns all fields' do
    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:group_id]).to_not be nil
    expect(serializer.serializable_hash[:enterprise]).to be nil
    expect(serializer.serializable_hash[:group]).to be nil
    expect(serializer.serializable_hash[:permissions]).to be nil
  end

  include_examples 'preloads serialized data', :annual_budget
end
