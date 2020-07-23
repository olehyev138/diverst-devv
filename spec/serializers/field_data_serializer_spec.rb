require 'rails_helper'

RSpec.describe FieldDataSerializer, type: :serializer do
  it 'returns field data' do
    field_data = create(:field_data)
    serializer = FieldDataSerializer.new(field_data, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq field_data.id
    expect(serializer.serializable_hash[:field_user_id]).to eq field_data.field_user_id
    expect(serializer.serializable_hash[:field_id]).to eq field_data.field_id
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end
