require 'rails_helper'

RSpec.describe NewsLinkPhoto, type: :model do
  describe 'test associations and validations' do
    let(:news_link_photo) { build_stubbed(:news_link_photo) }
    it { expect(news_link_photo).to belong_to(:news_link) }

    it { expect(news_link_photo).to validate_presence_of(:news_link).on(:update) }
    it { expect(news_link_photo).to have_attached_file(:file) }
    it { expect(news_link_photo).to validate_attachment_content_type(:file)
      .allowing('image/png', 'image/gif', 'image/jpeg', 'image/jpg')
      .rejecting('text/xml', 'text/plain')
    }

    it { expect(news_link_photo).to validate_length_of(:file_content_type).is_at_most(191) }
    it { expect(news_link_photo).to validate_length_of(:file_file_name).is_at_most(191) }
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
