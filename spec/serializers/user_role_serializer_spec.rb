require 'rails_helper'

RSpec.describe UserRoleSerializer, type: :serializer do
  it 'returns fields and enterprise' do
    user_role = create(:user_role)
    serializer = UserRoleSerializer.new(user_role, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:role_name]).to_not be nil
    expect(serializer.serializable_hash[:enterprise][:id]).to_not be nil
  end
end
