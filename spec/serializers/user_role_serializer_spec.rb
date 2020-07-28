require 'rails_helper'

RSpec.describe UserRoleSerializer, type: :serializer do
  let(:user_role) { create(:user_role) }
  let(:serializer) { UserRoleSerializer.new(user_role, scope: serializer_scopes(create(:user))) }

  include_examples 'permission container', :serializer

  it 'returns fields and enterprise' do
    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:role_name]).to_not be nil
    expect(serializer.serializable_hash[:enterprise][:id]).to_not be nil
  end
end
