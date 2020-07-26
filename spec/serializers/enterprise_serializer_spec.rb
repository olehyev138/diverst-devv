require 'rails_helper'

RSpec.describe EnterpriseSerializer, type: :serializer do
  it 'returns enterprise' do
    enterprise = create(:enterprise)
    serializer = EnterpriseSerializer.new(enterprise, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq enterprise.id
    expect(serializer.serializable_hash[:name]).to eq enterprise.name
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end
