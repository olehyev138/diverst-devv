require 'rails_helper'

RSpec.describe EventSerializer, type: :serializer do
  let(:event) { create(:initiative) }
  let(:serializer) { EventSerializer.new(event, scope: serializer_scopes(create(:user))) }

  it 'returns event' do
    expect(serializer.serializable_hash[:id]).to eq event.id
    expect(serializer.serializable_hash[:permissions]).to be nil
  end

  include_examples 'preloads serialized data', :event
end
