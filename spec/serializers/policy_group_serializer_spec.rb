require 'rails_helper'

RSpec.describe PolicyGroupSerializer, type: :serializer do
  it 'returns policy group' do
    user = create(:user)
    policy_group = user.policy_group
    serializer = PolicyGroupSerializer.new(policy_group, scope: serializer_scopes(user))

    expect(serializer.serializable_hash.key?('id')).to be false
    expect(serializer.serializable_hash.key?('user_id')).to be false
    expect(serializer.serializable_hash[:groups_index]).to eq(policy_group.groups_index)
  end
end
