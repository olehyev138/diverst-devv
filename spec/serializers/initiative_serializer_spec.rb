require 'rails_helper'

RSpec.describe InitiativeSerializer, type: :serializer do
  it 'returns associations' do
    budget = create(:approved)
    budget_item = create(:budget_item, budget: budget)
    initiative = create(:initiative,
                        budget_item_id: budget_item.id,
                        picture: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' },
                        qr_code: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' })
    serializer = InitiativeSerializer.new(initiative, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:pillar]).to_not be nil
    expect(serializer.serializable_hash[:owner]).to_not be nil
    expect(serializer.serializable_hash[:budget]).to_not be nil
    expect(serializer.serializable_hash[:outcome]).to_not be nil
    expect(serializer.serializable_hash[:budget_status]).to_not be nil
    expect(serializer.serializable_hash[:expenses_status]).to_not be nil
    expect(serializer.serializable_hash[:current_expenses_sum]).to_not be nil
    expect(serializer.serializable_hash[:leftover]).to_not be nil
    expect(serializer.serializable_hash[:picture_data]).to_not be nil
    expect(serializer.serializable_hash[:qr_code_data]).to_not be nil
    expect(serializer.serializable_hash[:full?]).to be false
  end
end
