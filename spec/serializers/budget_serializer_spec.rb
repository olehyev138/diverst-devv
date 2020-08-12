require 'rails_helper'

RSpec.describe BudgetSerializer, type: :serializer do
  let(:approver) { create(:user) }
  let(:requester) { create(:user) }
  let(:group) { create(:group) }
  let(:annual_budget) { create(:annual_budget, group: group) }
  let(:budget) { create(:budget, requester: requester, approver: approver, annual_budget: annual_budget) }

  let(:serializer) { BudgetSerializer.new(budget, scope: serializer_scopes(create(:user))) }

  include_examples 'permission container', :serializer

  it 'returns associations' do
    expect(serializer.serializable_hash[:id]).to eq(budget.id)
    expect(serializer.serializable_hash[:approver]).to_not be nil
    expect(serializer.serializable_hash[:requester]).to_not be nil
    expect(serializer.serializable_hash[:group_id]).to_not be nil
  end
end
