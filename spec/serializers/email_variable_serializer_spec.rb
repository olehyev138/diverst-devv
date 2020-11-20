require 'rails_helper'

RSpec.describe EmailVariableSerializer, type: :serializer do
  let(:email_variable) { create(:email_variable) }
  let(:serializer) { EmailVariableSerializer.new(email_variable, scope: serializer_scopes(create(:user))) }

  it 'returns email variable' do
    expect(serializer.serializable_hash[:id]).to be nil
    expect(serializer.serializable_hash[:email_id]).to eq email_variable.email_id
    expect(serializer.serializable_hash[:permissions]).to be nil
  end

  include_examples 'preloads serialized data', :email_variable
end
