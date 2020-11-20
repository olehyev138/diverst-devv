require 'rails_helper'

RSpec.describe FieldSerializer, type: :serializer do
  let(:field) { create(:field) }
  let(:serializer) { FieldSerializer.new(field, scope: serializer_scopes(create(:user))) }

  it 'returns fields' do
    expect(serializer.serializable_hash[:id]).to eq field.id
    expect(serializer.serializable_hash[:title]).to eq field.title
    expect(serializer.serializable_hash[:permissions]).to be nil
  end

  include_examples 'preloads serialized data', :field
end
