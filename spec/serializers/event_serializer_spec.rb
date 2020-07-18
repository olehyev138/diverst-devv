require 'rails_helper'

RSpec.describe EventSerializer, type: :serializer do
  it 'returns event' do
    event = create(:initiative)
    serializer = EventSerializer.new(event, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq event.id
  end
end
