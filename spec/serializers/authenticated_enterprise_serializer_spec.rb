require 'rails_helper'

RSpec.describe AuthenticatedEnterpriseSerializer, type: :serializer do
  let(:enterprise) { create(:enterprise) }
  let(:serializer) { AuthenticatedEnterpriseSerializer.new(enterprise, scope: serializer_scopes(create(:user))) }

  it 'returns Authenticated Enterprise' do
    expect(serializer.serializable_hash[:id]).to eq enterprise.id
    expect(serializer.serializable_hash[:name]).to eq enterprise.name
    expect(serializer.serializable_hash[:permissions]).to be nil
  end

  include_examples 'preloads serialized data', :enterprise
end
