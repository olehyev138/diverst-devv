require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  let(:public_field) { create(:field, private: false) }
  let(:private_field) { create(:field, private: true) }
  let(:enterprise) do
    create(
        :enterprise,
        fields: [
            public_field,
            private_field
        ]
      )
  end

  let(:user) do
    create(
        :user,
        avatar: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' },
        enterprise: enterprise,
        policy_group: create(:policy_group, :no_permissions),
      )
  end

  let(:admin_user) do
    create(
        :user,
        avatar: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' },
        enterprise: enterprise
      )
  end

  let(:serializer) { UserSerializer.new(user, scope: serializer_scopes(user)) }
  let(:admin_serializer) { UserSerializer.new(user, scope: serializer_scopes(admin_user)) }

  include_examples 'permission container', :serializer

  it 'returns email and last name fields but not password_digest' do
    create_list(:user_group, 3, user_id: user.id)
    expect(serializer.serializable_hash[:email]).to eq user.email
    expect(serializer.serializable_hash[:last_name]).to_not eq nil
    expect(serializer.serializable_hash[:user_role]).to_not eq nil
    expect(serializer.serializable_hash[:user_groups].empty?).to_not be true
    expect(serializer.serializable_hash[:password_digest]).to be nil
    expect(serializer.serializable_hash[:field_data].size).to be 1
    expect(serializer.serializable_hash[:status].size).to_not eq nil
  end

  it 'returns email and last name fields but not password_digest' do
    create_list(:user_group, 3, user_id: user.id)
    expect(admin_serializer.serializable_hash[:field_data].size).to be 2
  end
end
