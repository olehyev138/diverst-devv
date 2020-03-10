require 'rails_helper'

RSpec.describe BudgetItemSerializer, type: :serializer do
  it 'returns associations' do
    budget_item = create(:budget_item)

    serializer = BudgetItemSerializer.new(budget_item)

    expect(serializer.serializable_hash[:id]).to eq(budget_item.id)
    expect(serializer.serializable_hash[:budget]).to be nil
    expect(serializer.serializable_hash[:title_with_amount]).to_not be nil
    expect(serializer.serializable_hash[:available_amount]).to_not be nil
  end
end
