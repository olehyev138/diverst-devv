require 'rails_helper'

RSpec.describe InvitedUserSerializer, type: :serializer do
  it 'returns associations' do
    enterprise = create(:enterprise)
    invited_user = create(:user, enterprise: enterprise)

    serializer = InvitedUserSerializer.new(invited_user, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:email]).to eq(invited_user.email)
    expect(serializer.serializable_hash[:name]).to eq(invited_user.name)
    expect(serializer.serializable_hash[:enterprise]).to eq(EnterpriseSerializer.new(enterprise, scope: serializer_scopes(create(:user))).attributes)
  end
end
