require 'rails_helper'

RSpec.describe NewsLinkSerializer, type: :serializer do
  it 'returns associations' do
    news_link = create(:news_link, picture: File.new('spec/fixtures/files/verizon_logo.png'))
    create(:news_link_photo, news_link: news_link, file: File.new('spec/fixtures/files/verizon_logo.png'))
    serializer = NewsLinkSerializer.new(news_link)

    expect(serializer.serializable_hash[:group]).to_not be_nil
    expect(serializer.serializable_hash[:author]).to_not be_nil
    expect(serializer.serializable_hash[:news_feed_link]).to_not be_nil
    expect(serializer.serializable_hash[:picture_location]).to_not be_nil
    expect(serializer.serializable_hash[:photos].empty?).to_not be(true)

    photo_serializer = serializer.serializable_hash[:photos][0]
    expect(photo_serializer.serializable_hash[:file_location]).to_not be nil
  end
end
