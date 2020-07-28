require 'rails_helper'

RSpec.describe GroupLeaderSerializer, type: :serializer do
  it 'returns associations' do
    group_leader = create(:group_leader)
    serializer = GroupLeaderSerializer.new(group_leader, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:group]).to_not be_nil
    expect(serializer.serializable_hash[:user]).to_not be_nil
    expect(serializer.serializable_hash[:user_role]).to_not be_nil
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end
