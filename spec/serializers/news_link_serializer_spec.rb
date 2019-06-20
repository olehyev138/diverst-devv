require 'rails_helper'

RSpec.describe NewsLinkSerializer, type: :serializer do
  it 'returns associations' do
    news_link = create(:news_link)
    create(:news_link_photo, news_link: news_link)
    serializer = NewsLinkSerializer.new(news_link)

    expect(serializer.serializable_hash[:group]).to_not be_nil
    expect(serializer.serializable_hash[:author]).to_not be_nil
    expect(serializer.serializable_hash[:photos].empty?).to_not be(true)
  end
end
