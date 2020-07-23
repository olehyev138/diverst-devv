require 'rails_helper'

RSpec.describe NewsLinkPhotoSerializer, type: :serializer do
  it 'returns news link photo' do
    news_link = create(:news_link, picture: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' })
    news_link_photo = create(:news_link_photo, news_link: news_link, file: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' })
    serializer = NewsLinkPhotoSerializer.new(news_link_photo, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:file_file_name]).to eq(news_link_photo.file_file_name)
    expect(serializer.serializable_hash[:file_location]).to_not be nil
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end
