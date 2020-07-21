require 'rails_helper'

RSpec.describe NewsLinkSerializer, type: :serializer do
  it 'returns associations' do
    news_link = create(:news_link, picture: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' })
    create(:news_link_photo, news_link: news_link, file: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' })
    serializer = NewsLinkSerializer.new(news_link, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:group]).to be_nil
    expect(serializer.serializable_hash[:group_id]).to_not be_nil
    expect(serializer.serializable_hash[:author]).to_not be_nil
    expect(serializer.serializable_hash[:news_feed_link]).to be_nil
    expect(serializer.serializable_hash[:picture_location]).to_not be_nil
    expect(serializer.serializable_hash[:photos].empty?).to_not be(true)

    photo_serializer = serializer.serializable_hash[:photos][0]
    expect(photo_serializer.serializable_hash[:file_location]).to_not be nil
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end
