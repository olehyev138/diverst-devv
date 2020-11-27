require 'rails_helper'

RSpec.describe BudgetItemSerializer, type: :serializer do
  let(:budget_item) { create(:budget_item) }
  let(:serializer) { BudgetItemSerializer.new(budget_item, scope: serializer_scopes(create(:user))) }

  it 'returns associations' do
    expect(serializer.serializable_hash[:id]).to eq(budget_item.id)
    expect(serializer.serializable_hash[:budget]).to be nil
    expect(serializer.serializable_hash[:title_with_amount]).to_not be nil
    expect(serializer.serializable_hash[:available_amount]).to_not be nil
    expect(serializer.serializable_hash[:permissions]).to be nil
  end

  include_examples 'preloads serialized data', :budget_item
end
