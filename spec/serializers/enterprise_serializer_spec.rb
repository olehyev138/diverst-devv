require 'rails_helper'

RSpec.describe EnterpriseSerializer, type: :serializer do
  it 'returns field data' do
    enterprise = create(:enterprise)
    serializer = EnterpriseSerializer.new(enterprise, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to eq enterprise.id
    expect(serializer.serializable_hash[:name]).to eq enterprise.name
  end
end
