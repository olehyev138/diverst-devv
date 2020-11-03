require 'rails_helper'

RSpec.describe EnterpriseEmailVariableSerializer, type: :serializer do
  let(:enterprise_email_variable) { create(:enterprise_email_variable) }
  let(:serializer) { EnterpriseEmailVariableSerializer.new(enterprise_email_variable, scope: serializer_scopes(create(:user))) }

  it 'returns enterprise email variable' do
    expect(serializer.serializable_hash[:id]).to eq enterprise_email_variable.id
    expect(serializer.serializable_hash[:enterprise_id]).to eq enterprise_email_variable.enterprise_id
    expect(serializer.serializable_hash[:key]).to eq enterprise_email_variable.key
    expect(serializer.serializable_hash[:permissions]).to be nil
  end

  include_examples 'preloads serialized data', :enterprise_email_variable
end
