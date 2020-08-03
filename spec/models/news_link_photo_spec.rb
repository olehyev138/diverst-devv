require 'rails_helper'

RSpec.describe NewsLinkPhoto, type: :model do
  describe 'test associations and validations' do
    let(:news_link_photo) { build(:news_link_photo) }
    it { expect(news_link_photo).to belong_to(:news_link) }
    it { expect(news_link_photo).to validate_presence_of(:news_link).on(:update) }

    # ActiveStorage
    it { expect(news_link_photo).to have_attached_file(:file) }
    it { expect(news_link_photo).to validate_attachment_presence(:file) }
    it { expect(news_link_photo).to validate_attachment_content_type(:file, AttachmentHelper.common_image_types) }
  end

  describe 'file_location' do
    it 'returns file location' do
      news_link_photo = create(:news_link_photo)
      expect(news_link_photo.file_location).to_not be nil
    end
  end

  describe '#group' do
    it 'returns the group the news_link belongs to' do
      group = create(:group)
      news_link = build(:news_link, group: group)
      news_link_photo = create(:news_link_photo, news_link: news_link)
      expect(news_link_photo.group.id).to eq(group.id)
    end
  end
end
