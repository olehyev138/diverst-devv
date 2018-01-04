require 'rails_helper'

RSpec.describe ConversationSerializer, :type => :serializer do
  it "returns user, saved and expires soon fields" do
    user1 = create(:user)
    user2 = create(:user)
    topic = create(:topic, :user_id => user1.id, :enterprise => user1.enterprise)
    
    match = create(:match, :user1 => user1, :user2 => user2, :topic => topic, :user1_status => 1, :user2_status => 1, :both_accepted_at => Date.yesterday)
    serializer = ConversationSerializer.new(match, {:scope => user1})
    
    expect(serializer.serializable_hash[:user]).to_not be(nil)
    expect(serializer.serializable_hash[:saved]).to_not be(nil)
    expect(serializer.serializable_hash[:expires_soon]).to_not be(nil)
  end
end