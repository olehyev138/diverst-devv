require 'rails_helper'

RSpec.describe FieldDataSerializer, type: :serializer do
  let(:field_data) { create(:field_data) }
  let(:serializer) { FieldDataSerializer.new(field_data, scope: serializer_scopes(create(:user))) }

  it 'returns field data' do
    expect(serializer.serializable_hash[:id]).to eq field_data.id
    expect(serializer.serializable_hash[:field_user_id]).to eq field_data.field_user_id
    expect(serializer.serializable_hash[:field_id]).to eq field_data.field_id
    expect(serializer.serializable_hash[:permissions]).to be nil
  end

  include_examples 'preloads serialized data', :field_data
end
