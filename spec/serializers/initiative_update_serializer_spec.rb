require 'rails_helper'

RSpec.describe InitiativeUpdateSerializer, type: :serializer do
  it 'returns associations' do
    initiative_update = create(:initiative_update)

    serializer = InitiativeUpdateSerializer.new(initiative_update, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(initiative_update.id)
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end
