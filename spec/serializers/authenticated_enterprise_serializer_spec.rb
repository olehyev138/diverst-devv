require 'rails_helper'

RSpec.describe AuthenticatedEnterpriseSerializer, type: :serializer do
  it 'returns Authenticated Enterprise' do
    enterprise = create(:enterprise)
    serializer = AuthenticatedEnterpriseSerializer.new(enterprise, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq enterprise.id
    expect(serializer.serializable_hash[:name]).to eq enterprise.name
    expect(serializer.serializable_hash[:permissions]).to be nil
  end

  include_examples 'preloads serialized data', :enterprise
end
