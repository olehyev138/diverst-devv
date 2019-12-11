require 'rails_helper'
include ActionDispatch::TestProcess

RSpec.describe NewsLink, type: :model do
  describe 'validations' do
    let(:news_link) { build(:news_link) }

    it { expect(news_link).to validate_presence_of(:group_id) }
    it { expect(news_link).to validate_presence_of(:title) }
    it { expect(news_link).to validate_presence_of(:description) }
    it { expect(news_link).to validate_presence_of(:author_id) }

    it { expect(news_link).to belong_to(:group) }
    it { expect(news_link).to belong_to(:author).class_name('User') }

    it { expect(news_link).to have_many(:segments).through(:news_link_segments) }

    it { expect(news_link).to have_many(:comments).class_name('NewsLinkComment').dependent(:destroy) }
    it { expect(news_link).to have_many(:photos).class_name('NewsLinkPhoto').dependent(:destroy) }
    it { expect(news_link).to have_many(:news_link_segments).dependent(:destroy) }
    it { expect(news_link).to have_many(:news_link_photos).dependent(:destroy) }
    it { expect(news_link).to have_one(:news_feed_link) }
    it { expect(news_link).to accept_nested_attributes_for(:photos).allow_destroy(true) }

    # ActiveStorage
    it { expect(news_link).to have_attached_file(:picture) }
    it { expect(news_link).to validate_attachment_content_type(:picture, AttachmentHelper.common_image_types) }

    it 'validates url length' do
      expect(build(:news_link, url: 'www.goodurl.com')).to be_valid
      expect(build(:news_link, url: 'badurl' * 300)).to_not be_valid
    end
  end

  describe '#build' do
    it 'sets the picture for news link and file for nested news link photo from url when creating news link' do
      user = create(:user)
      group = create(:group, enterprise: user.enterprise)
      request = Request.create_request(user)

      picture = fixture_file_upload('spec/fixtures/files/verizon_logo.png', 'image/png')
      photo_file = fixture_file_upload('spec/fixtures/files/verizon_logo.png', 'image/png')

      payload = {
        news_link: {
          title: 'Test',
          group_id: group.id,
          author_id: user.id,
          description: Faker::Lorem.sentence,
          picture: picture,
          photos_attributes: [{ file: photo_file }]
        }
      }
      params = ActionController::Parameters.new(payload)
      created = NewsLink.build(request, params.permit!)

      expect(created.picture.attached?).to be true
      expect(created.photos.exists?).to_not be false
      expect(created.photos.first.presence).to_not be nil
    end
  end

  describe 'test callbacks' do
    let!(:news_link) { build(:news_link) }

    it '#build_default_link' do
      expect(news_link).to receive(:build_default_link)
      news_link.save
    end
  end

  describe '.of_segments' do
    let(:author) { create(:user) }

    let(:segment1) { build :segment, enterprise: author.enterprise }
    let(:segment2) { build :segment, enterprise: author.enterprise }

    let!(:news_link_without_segment) { create(:news_link, author_id: author.id, segments: []) }
    let!(:news_link_with_segment) { create(:news_link, author_id: author.id, segments: [segment1]) }
    let!(:news_link_with_another_segment) {
      create(:news_link, author_id: author.id, segments: [segment2])
    }

    it 'returns initiatives that has specific segments or does not have any segment' do
      expect(NewsLink.of_segments([segment1.id])).to match_array([news_link_without_segment, news_link_with_segment])
    end
  end

  describe '#news_feed_link' do
    it 'has default news_feed_link' do
      user = create(:user)
      news_link = create(:news_link, author: user)
      expect(news_link.news_feed_link).to_not be_nil
    end
  end

  describe '#remove_segment_association' do
    it 'removes segment association' do
      news_link = create(:news_link)
      segment = create(:segment)

      news_link.segment_ids = [segment.id]
      news_link.save

      expect(news_link.segments.length).to eq(1)
      expect(news_link.news_link_segments.length).to eq(1)

      news_link_segment = news_link.news_link_segments.where(segment_id: segment.id).first

      expect(news_link_segment.news_feed_link_segment).to_not be(nil)

      news_link.remove_segment_association(segment)

      expect(news_link_segment.news_feed_link_segment).to_not be(nil)
    end
  end

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      news_link = create(:news_link)
      segment = create(:news_link_segment, news_link: news_link)
      photo = create(:news_link_photo, news_link: news_link)

      news_link.destroy

      expect { NewsLink.find(news_link.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { NewsLinkSegment.find(segment.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { NewsLinkPhoto.find(photo.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
