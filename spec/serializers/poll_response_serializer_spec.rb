require 'rails_helper'

RSpec.describe PollResponseSerializer, type: :serializer do
  it 'returns associations' do
    poll_response = create(:poll_response)

    serializer = PollResponseSerializer.new(poll_response, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(poll_response.id)
    expect(serializer.serializable_hash[:field_data].blank?).to be false
    expect(serializer.serializable_hash[:user]).to_not be_nil
    expect(serializer.serializable_hash[:poll]).to_not be_nil
    expect(serializer.serializable_hash[:permissions]).to be nil
  end

  xit 'returns associations except for user for anonymous responses' do
    poll_response = create(:poll_response, :anonymous)

    serializer = PollResponseSerializer.new(poll_response, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(poll_response.id)
    expect(serializer.serializable_hash[:field_data].blank?).to be false
    expect(serializer.serializable_hash[:user]).to be_nil
    expect(serializer.serializable_hash[:poll]).to be_nil
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end
