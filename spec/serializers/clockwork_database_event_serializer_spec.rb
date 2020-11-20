require 'rails_helper'

RSpec.describe ClockworkDatabaseEventSerializer, type: :serializer do
  let(:clockwork_database_event) { create(:clockwork_database_event) }
  let(:serializer) { ClockworkDatabaseEventSerializer.new(clockwork_database_event, scope: serializer_scopes(create(:user))) }

  it 'returns clockwork_database_event' do
    expect(serializer.serializable_hash[:id]).to eq clockwork_database_event.id
    expect(serializer.serializable_hash[:name]).to eq clockwork_database_event.name
    expect(serializer.serializable_hash[:frequency]).to eq clockwork_database_event.frequency_quantity.send(clockwork_database_event.frequency_period.name.pluralize)
    expect(serializer.serializable_hash[:frequency_period]).to eq clockwork_database_event.frequency_period
    expect(serializer.serializable_hash[:permissions]).to be nil
  end

  include_examples 'preloads serialized data', :clockwork_database_event
end