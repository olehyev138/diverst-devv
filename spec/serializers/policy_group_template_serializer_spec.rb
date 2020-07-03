require 'rails_helper'

RSpec.describe PolicyGroupSerializer, type: :serializer do
  it 'returns policy group' do
    user_role = create(:user_role)
    policy_group_template = user_role.policy_group_template
    serializer = PolicyGroupSerializer.new(policy_group_template, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash.key?('manage_all')).to be false
    expect(serializer.serializable_hash.key?('user_id')).to be false
    expect(serializer.serializable_hash[:user_role_id]).to eq(policy_group_template.user_role_id)
    expect(serializer.serializable_hash[:groups_index]).to eq(policy_group_template.groups_index)
  end
end
