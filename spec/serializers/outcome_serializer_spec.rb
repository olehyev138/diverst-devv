require 'rails_helper'

RSpec.describe OutcomeSerializer, type: :serializer do
  it 'returns associations' do
    group = create(:group)
    outcome = create(:outcome, group: group)

    serializer = OutcomeSerializer.new(outcome, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(outcome.id)
    expect(serializer.serializable_hash[:group]).to_not be nil
  end
end
