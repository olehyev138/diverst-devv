require 'rails_helper'

RSpec.describe UsersSegmentSerializer, type: :serializer do
  it 'returns user segment' do
    users_segment = create(:users_segment)
    serializer = UsersSegmentSerializer.new(users_segment, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to eq(users_segment.id)
    expect(serializer.serializable_hash[:user_id]).to eq(users_segment.user_id)
    expect(serializer.serializable_hash[:segment_id]).to eq(users_segment.segment_id)
  end
end
