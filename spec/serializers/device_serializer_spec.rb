require 'rails_helper'

RSpec.describe DeviceSerializer, type: :serializer do
  let(:device) { create(:device) }
  let(:serializer) { DeviceSerializer.new(device, scope: serializer_scopes(create(:user))) }

  it 'returns fields' do
    expect(serializer.serializable_hash[:id]).to eq device.id
    expect(serializer.serializable_hash[:token]).to_not be nil
    expect(serializer.serializable_hash[:user_id]).to_not be nil
    expect(serializer.serializable_hash[:permissions]).to be nil
  end

  include_examples 'preloads serialized data', :device
end
