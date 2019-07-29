require 'rails_helper'

RSpec.describe TwitterAccountSerializer, type: :serializer do
  it 'returns associations' do
    twitter_account = create(:twitter_account)
    serializer = TwitterAccountSerializer.new(twitter_account)

    expect(serializer.serializable_hash[:id]).to_not be_nil
    expect(serializer.serializable_hash[:group_id]).to_not be_nil
    expect(serializer.serializable_hash[:account]).to_not be_nil
    expect(serializer.serializable_hash[:name]).to_not be_nil
  end
end
