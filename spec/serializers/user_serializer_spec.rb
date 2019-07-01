require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  it 'returns email and last name fields but not password_digest' do
    user = create(:user)
    serializer = UserSerializer.new(user)

    expect(serializer.serializable_hash[:email]).to eq user.email
    expect(serializer.serializable_hash[:last_name]).to_not eq nil
    expect(serializer.serializable_hash[:password_digest]).to be nil
  end
end
