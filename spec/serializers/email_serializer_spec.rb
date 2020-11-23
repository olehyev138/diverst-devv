require 'rails_helper'

RSpec.describe EmailSerializer, type: :serializer do
  let(:email) { create(:email) }
  let(:enterprise_email_variable) { create(:enterprise_email_variable) }
  let(:email_variables) { create_list(:email_variable, 3, email_id: email.id, enterprise_email_variable_id: enterprise_email_variable.id) }
  let(:serializer) { EmailSerializer.new(email, scope: serializer_scopes(create(:user))) }

  it 'returns emails' do
    variables = email_variables.reduce({}) do |sum, var|
      join_vars = EmailVariableSerializer.new(var).as_json
      real_vars = EnterpriseEmailVariableSerializer.new(var.enterprise_email_variable).as_json

      sum.merge({ var.enterprise_email_variable.key => join_vars.merge(real_vars) })
    end

    expect(serializer.serializable_hash[:id]).to eq email.id
    expect(serializer.serializable_hash[:variables]).to eq variables
    expect(serializer.serializable_hash[:permissions]).to be nil
  end

  include_examples 'preloads serialized data', :email
end
