require 'rails_helper'

RSpec.describe ActivitySerializer, type: :serializer do
  it 'returns activity' do
    activity = create(:activity)
    serializer = ActivitySerializer.new(activity, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:owner_id]).to_not be nil
  end
end
