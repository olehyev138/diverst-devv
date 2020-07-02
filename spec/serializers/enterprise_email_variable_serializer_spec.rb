require 'rails_helper'

RSpec.describe EnterpriseEmailVariableSerializer, type: :serializer do
  it 'returns event' do
    enterprise_email_variable = create(:enterprise_email_variable)
    serializer = EnterpriseEmailVariableSerializer.new(enterprise_email_variable, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to eq enterprise_email_variable.id
    expect(serializer.serializable_hash[:enterprise_id]).to eq enterprise_email_variable.enterprise_id
    expect(serializer.serializable_hash[:key]).to eq enterprise_email_variable.key
  end
end
