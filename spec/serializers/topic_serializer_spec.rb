require 'rails_helper'

RSpec.describe TopicSerializer, type: :serializer do
  it 'returns topic' do
    topic = create(:topic)
    serializer = TopicSerializer.new(topic, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(topic.id)
    expect(serializer.serializable_hash[:statement]).to eq(topic.statement)
  end
end
