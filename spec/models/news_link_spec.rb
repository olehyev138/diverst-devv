require 'rails_helper'

RSpec.describe NewsLink, type: :model do
  describe 'test associations and validations' do
    let(:news_link) { build_stubbed(:news_link) }

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
    it { expect(news_link).to have_many(:user_reward_actions) }

    it { expect(news_link).to have_one(:news_feed_link) }

    it { expect(news_link).to accept_nested_attributes_for(:photos).allow_destroy(true) }

    it { expect(news_link).to have_attached_file(:picture) }
    it { expect(news_link).to validate_attachment_content_type(:picture)
        .allowing('image/png', 'image/jpeg', 'image/jpg')
        .rejecting('text/xml', 'text/plain')
    }

    it { expect(news_link).to delegate_method(:increment_view).to(:news_feed_link) }
    it { expect(news_link).to delegate_method(:total_views).to(:news_feed_link) }
    it { expect(news_link).to delegate_method(:unique_views).to(:news_feed_link) }

    it 'validates url length' do
      expect(build(:news_link, url: 'www.goodurl.com')).to be_valid
      expect(build(:news_link, url: 'badurl' * 300)).to_not be_valid
    end

    it { expect(news_link).to validate_length_of(:picture_content_type).is_at_most(191) }
    it { expect(news_link).to validate_length_of(:picture_file_name).is_at_most(191) }
    it { expect(news_link).to validate_length_of(:description).is_at_most(65535) }
    it { expect(news_link).to validate_length_of(:title).is_at_most(191) }
  end

  describe 'test callbacks' do
    let!(:news_link) { build(:news_link) }

    it '#build_default_link' do
      expect(news_link).to receive(:build_default_link)
      news_link.save
    end
  end

  describe 'test scopes' do
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
        expect(described_class.of_segments([segment1.id])).to match_array([news_link_without_segment, news_link_with_segment])
      end
    end

    describe '.unapproved' do
      it 'returns unapproved news_links' do
        news_link = create(:news_link)
        news_link.news_feed_link.update(approved: false)

        expect(described_class.unapproved).to eq([news_link])
      end
    end

    describe '.approved' do
      it 'returns approved news_links' do
        news_link = create(:news_link)
        expect(described_class.approved).to eq([news_link])
      end
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

  describe '.comments_count' do
    let!(:news_link) { create(:news_link) }
    let!(:approved_comments) { create_list(:news_link_comment, 1, news_link_id: news_link.id, approved: true) }
    let!(:unapproved_comments) { create_list(:news_link_comment,  2, news_link_id: news_link.id, approved: false) }

    context 'when enable_pending_comments is set to true' do
      before { news_link.group.enterprise.update(enable_pending_comments: true) }

      it 'returns approved comments count' do
        expect(news_link.comments_count).to eq(1)
      end
    end

    context 'when enable_pending_comments is set to false' do
      it 'returns comments count' do
        expect(news_link.comments_count).to eq(3)
      end
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
