require 'rails_helper'

RSpec.describe PillarSerializer, type: :serializer do
  it 'returns associations' do
    group = create(:group)
    outcome = create(:outcome, group: group)
    pillar = create(:pillar, outcome: outcome)
    initiative = create(:initiative, pillar: pillar)

    serializer = PillarSerializer.new(pillar, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(pillar.id)
    expect(serializer.serializable_hash[:outcome_id]).to eq(outcome.id)
    expect(serializer.serializable_hash[:initiatives][0][:id]).to eq(initiative.id)
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end
