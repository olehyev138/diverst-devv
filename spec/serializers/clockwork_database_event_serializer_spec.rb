require 'rails_helper'

RSpec.describe ClockworkDatabaseEventSerializer, type: :serializer do
  it 'returns fields' do
    clockwork_database_event = create(:clockwork_database_event)
    serializer = ClockworkDatabaseEventSerializer.new(clockwork_database_event, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to eq clockwork_database_event.id
    expect(serializer.serializable_hash[:name]).to eq clockwork_database_event.name
    expect(serializer.serializable_hash[:frequency]).to eq clockwork_database_event.frequency_quantity.send(clockwork_database_event.frequency_period.name.pluralize)
    expect(serializer.serializable_hash[:frequency_period]).to eq clockwork_database_event.frequency_period
  end
end
