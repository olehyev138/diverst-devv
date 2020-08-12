require 'rails_helper'

RSpec.describe PolicyGroupSerializer, type: :serializer do
  let(:user_role) { create(:user_role) }
  let(:policy_group_template) { user_role.policy_group_template }
  let(:serializer) { PolicyGroupTemplateSerializer.new(policy_group_template, scope: serializer_scopes(create(:user))) }

  include_examples 'permission container', :serializer

  it 'returns policy group' do
    expect(serializer.serializable_hash.key?('manage_all')).to be false
    expect(serializer.serializable_hash.key?('user_id')).to be false
    expect(serializer.serializable_hash[:user_role_id]).to eq(policy_group_template.user_role_id)
    expect(serializer.serializable_hash[:groups_index]).to eq(policy_group_template.groups_index)
  end
end
