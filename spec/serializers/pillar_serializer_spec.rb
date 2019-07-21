require 'rails_helper'

RSpec.describe PillarSerializer, type: :serializer do
  it 'returns associations' do
    group = create(:group)
    outcome = create(:outcome, group: group)
    pillar = create(:pillar, outcome: outcome)

    serializer = PillarSerializer.new(pillar)

    expect(serializer.serializable_hash[:id]).to eq(pillar.id)
    expect(serializer.serializable_hash[:outcome]).to_not be nil
  end
end
