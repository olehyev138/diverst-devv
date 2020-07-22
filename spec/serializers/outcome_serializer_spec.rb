require 'rails_helper'

RSpec.describe OutcomeSerializer, type: :serializer do
  let(:group) { create(:group) }
  let(:outcome) { create(:outcome, group: group) }

  let(:serializer) { OutcomeSerializer.new(outcome, scope: serializer_scopes(create(:user))) }

  include_examples 'permission container', :serializer

  it 'returns associations' do
    expect(serializer.serializable_hash[:id]).to eq(outcome.id)
    expect(serializer.serializable_hash[:group]).to_not be nil
  end
end
