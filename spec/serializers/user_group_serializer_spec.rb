require 'rails_helper'

RSpec.describe UserGroupSerializer, type: :serializer do
  it 'returns email and last name fields but not password_digest' do
    user_group = create(:user_group)
    serializer = UserGroupSerializer.new(user_group)

    expect(serializer.serializable_hash[:user]).to_not be nil
    expect(serializer.serializable_hash[:group]).to_not be nil
  end
end
