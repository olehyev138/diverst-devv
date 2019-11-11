require 'rails_helper'

RSpec.describe InitiativeSerializer, type: :serializer do
  it 'returns associations' do
    budget = create(:budget)
    budget_item = create(:budget_item, budget: budget)
    initiative = create(:initiative,
                        budget_item_id: budget_item.id,
                        picture: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' },
                        qr_code: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' })
    serializer = InitiativeSerializer.new(initiative)

    expect(serializer.serializable_hash[:pillar]).to_not be nil
    expect(serializer.serializable_hash[:owner]).to_not be nil
    expect(serializer.serializable_hash[:budget]).to_not be nil
    expect(serializer.serializable_hash[:outcome]).to_not be nil
    expect(serializer.serializable_hash[:budget_status]).to_not be nil
    expect(serializer.serializable_hash[:expenses_status]).to_not be nil
    expect(serializer.serializable_hash[:current_expences_sum]).to_not be nil
    expect(serializer.serializable_hash[:leftover]).to_not be nil
    expect(serializer.serializable_hash[:picture_location]).to_not be nil
    expect(serializer.serializable_hash[:qr_code_location]).to_not be nil
    expect(serializer.serializable_hash[:full?]).to be false
  end
end
