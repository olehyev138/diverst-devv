require 'rails_helper'

RSpec.describe EnterpriseSerializer, type: :serializer do
  let(:enterprise) { create(:enterprise) }
  let(:serializer) { EnterpriseSerializer.new(enterprise, scope: serializer_scopes(create(:user))) }

  it 'returns enterprise' do
    expect(serializer.serializable_hash[:id]).to eq enterprise.id
    expect(serializer.serializable_hash[:name]).to eq enterprise.name
    expect(serializer.serializable_hash[:permissions]).to be nil
  end

  include_examples 'preloads serialized data', :enterprise
end
