require 'rails_helper'

RSpec.describe BudgetSerializer, type: :serializer do
  it 'returns associations' do
    approver = create(:user)
    requester = create(:user)
    group = create(:group)
    budget = create(:budget, requester: requester, approver: approver, group: group)

    serializer = BudgetSerializer.new(budget)

    expect(serializer.serializable_hash[:id]).to eq(budget.id)
    expect(serializer.serializable_hash[:approver]).to_not be nil
    expect(serializer.serializable_hash[:requester]).to_not be nil
    expect(serializer.serializable_hash[:group]).to_not be nil
  end
end
