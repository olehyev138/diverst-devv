require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  it 'returns email and last name fields but not password_digest' do
    user = create(:user, avatar: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' })
    create_list(:user_group, 3, user_id: user.id)
    serializer = UserSerializer.new(user, scope: serializer_scopes(user), scope_name: :scope)

    expect(serializer.serializable_hash[:email]).to eq user.email
    expect(serializer.serializable_hash[:last_name]).to_not eq nil
    expect(serializer.serializable_hash[:user_role]).to_not eq nil
    expect(serializer.serializable_hash[:user_groups].empty?).to_not be true
    expect(serializer.serializable_hash[:password_digest]).to be nil
  end
end
