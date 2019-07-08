require 'rails_helper'

RSpec.describe UserGroupSerializer, type: :serializer do
  it 'returns email and last name fields but not password_digest' do
    enterprise = create(:enterprise)
    user = create(:user, enterprise: enterprise)
    group = create(:group, enterprise: enterprise)
    user_group = create(:user_group, user: user, group: group)
    serializer = UserGroupSerializer.new(user_group)

    expect(serializer.serializable_hash[:user][:email]).to_not be nil
    expect(serializer.serializable_hash[:group][:name]).to_not be nil
  end
end
