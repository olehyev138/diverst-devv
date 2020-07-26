require 'rails_helper'

RSpec.describe SocialLinkSerializer, type: :serializer do
  it 'returns associations' do
    social_link = create(:social_link)
    serializer = SocialLinkSerializer.new(social_link, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:group]).to be_nil
    expect(serializer.serializable_hash[:group_id]).to_not be_nil
    expect(serializer.serializable_hash[:author]).to_not be_nil
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end
