require 'rails_helper'

RSpec.describe InitiativeExpenseSerializer, type: :serializer do
  it 'returns associations' do
    initiative_expense = create(:initiative_expense)

    serializer = InitiativeExpenseSerializer.new(initiative_expense)

    expect(serializer.serializable_hash[:id]).to eq(initiative_expense.id)
    expect(serializer.serializable_hash[:owner]).to_not be nil
    expect(serializer.serializable_hash[:initiative]).to_not be nil
  end
end
