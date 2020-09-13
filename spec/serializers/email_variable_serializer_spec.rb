require 'rails_helper'

RSpec.describe EmailVariableSerializer, type: :serializer do
  it 'returns email variable' do
    email_variable = create(:email_variable)
    serializer = EmailVariableSerializer.new(email_variable, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to be nil
    expect(serializer.serializable_hash[:email_id]).to eq email_variable.email_id
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end