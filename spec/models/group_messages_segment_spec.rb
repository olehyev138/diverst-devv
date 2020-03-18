require 'rails_helper'

RSpec.describe GroupMessagesSegment, type: :model do
  describe 'validations' do
    let(:group_messages_segment) { build_stubbed(:group_messages_segment) }

    it { expect(group_messages_segment).to validate_presence_of(:group_message_id).on(:save) }
    it { expect(group_messages_segment).to validate_presence_of(:segment_id).on(:save) }

    it { expect(group_messages_segment).to belong_to(:group_message) }
    it { expect(group_messages_segment).to belong_to(:segment) }
    it { expect(group_messages_segment).to have_one(:news_feed_link_segment).dependent(:destroy) }
  end

  describe '#news_feed_link_segment' do
    it 'has default news_feed_link_segment' do
      group_messages_segment = create(:group_messages_segment)
      expect(group_messages_segment.news_feed_link_segment).to_not be_nil
    end
  end

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      group_messages_segment = create(:group_messages_segment)
      news_feed_link_segment = group_messages_segment.news_feed_link_segment

      group_messages_segment.destroy!

      expect { GroupMessagesSegment.find(group_messages_segment.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { NewsFeedLinkSegment.find(news_feed_link_segment.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'test before_create callback' do
    let!(:group_messages_segment) { build(:group_messages_segment) }

    it 'run build_default_link_segment before object creation' do
      expect(group_messages_segment).to receive(:build_default_link_segment)
      group_messages_segment.save
    end
  end
end
