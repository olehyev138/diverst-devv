require 'rails_helper'

RSpec.describe SocialLinkSegment, type: :model do
  describe 'validations' do
    let(:social_link_segment) { build_stubbed(:social_link_segment) }

    it { expect(social_link_segment).to validate_presence_of(:social_link_id).on(:save) }
    it { expect(social_link_segment).to validate_presence_of(:segment_id).on(:save) }

    it { expect(social_link_segment).to belong_to(:social_link) }
    it { expect(social_link_segment).to belong_to(:segment) }

    it { expect(social_link_segment).to have_one(:news_feed_link_segment).dependent(:destroy) }
  end

  describe 'test callbacks' do
    let!(:social_link_segment) { build(:social_link_segment) }

    it '#build_default_link_segment should be called before create' do
      expect(social_link_segment).to receive(:build_default_link_segment)
      social_link_segment.save
    end
  end

  describe '#news_feed_link_segment' do
    it 'has default news_feed_link_segment' do
      social_link_segment = create(:social_link_segment)
      expect(social_link_segment.news_feed_link_segment).to_not be_nil
    end
  end
end
