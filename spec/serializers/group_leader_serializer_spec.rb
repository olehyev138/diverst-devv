require 'rails_helper'

RSpec.describe GroupLeaderSerializer, type: :serializer do
  it 'returns associations' do
    group_leader = create(:group_leader)
    region_leader = create(:region_leader)
    serializer = GroupLeaderSerializer.new(group_leader, scope: serializer_scopes(create(:user)))
    region_serializer = GroupLeaderSerializer.new(region_leader, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:group]).to_not be_nil
    expect(serializer.serializable_hash[:region]).to be_nil

    expect(region_serializer.serializable_hash[:group]).to be_nil
    expect(region_serializer.serializable_hash[:region]).to_not be_nil

    expect(serializer.serializable_hash[:user]).to_not be_nil
    expect(serializer.serializable_hash[:user_role]).to_not be_nil
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end
