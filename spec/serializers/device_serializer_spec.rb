require 'rails_helper'

RSpec.describe DeviceSerializer, type: :serializer do
  it 'returns fields' do
    device = create(:device)
    serializer = DeviceSerializer.new(device)

    expect(serializer.serializable_hash[:id]).to eq device.id
    expect(serializer.serializable_hash[:token]).to_not be nil
    expect(serializer.serializable_hash[:user_id]).to_not be nil
  end
end
