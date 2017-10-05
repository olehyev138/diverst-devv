require 'rails_helper'

RSpec.describe GroupMessagesSegment, type: :model do
    
    describe 'validations' do
        let(:group_messages_segment) { FactoryGirl.build_stubbed(:group_messages_segment) }

        it{ expect(group_messages_segment).to validate_presence_of(:group_message_id).on(:save) }
        it{ expect(group_messages_segment).to validate_presence_of(:segment_id).on(:save) }
        
        it { expect(group_messages_segment).to belong_to(:group_message) }
        it { expect(group_messages_segment).to belong_to(:segment) }
    end
    
    describe "#news_feed_link_segment" do
        it "has default news_feed_link_segment" do
            group_messages_segment = create(:group_messages_segment)
            expect(group_messages_segment.news_feed_link_segment).to_not be_nil
        end
    end
end
