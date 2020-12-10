require 'rails_helper'

RSpec.describe ActivitySerializer, type: :serializer do
  let(:activity) { create(:activity) }
  let(:serializer) { ActivitySerializer.new(activity, scope: serializer_scopes(create(:user))) }

  it 'returns activity' do
    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:owner_id]).to_not be nil
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end
