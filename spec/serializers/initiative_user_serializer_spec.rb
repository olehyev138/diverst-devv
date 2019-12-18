require 'rails_helper'

RSpec.describe InitiativeUserSerializer, type: :serializer do
  it 'returns associations' do
    initiative_user = create(:initiative_user)

    serializer = InitiativeUserSerializer.new(initiative_user)

    expect(serializer.serializable_hash[:id]).to eq(initiative_user.id)
    expect(serializer.serializable_hash[:user]).to_not be nil
    expect(serializer.serializable_hash[:initiative]).to_not be nil
    expect(serializer.serializable_hash[:initiative].key?(:picture_location)).to be true
  end
end