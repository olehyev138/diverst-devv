require 'rails_helper'

RSpec.describe GroupMessage, type: :model do
    
    describe 'validations' do
        let(:group_message) { FactoryGirl.build_stubbed(:group_message) }

        it{ expect(group_message).to validate_presence_of(:group_id) }
        it{ expect(group_message).to validate_presence_of(:subject) }
        it{ expect(group_message).to validate_presence_of(:content) }
        it{ expect(group_message).to validate_presence_of(:owner_id) }
        
        it { expect(group_message).to belong_to(:group) }
        it { expect(group_message).to belong_to(:owner) }
        
        it{ expect(group_message).to have_many(:segments).through(:group_messages_segments) }
        
        it { expect(group_message).to have_many(:comments) }
        it { expect(group_message).to have_one(:news_feed_link)}
    end
    
    describe '#owner_name' do
        let(:user) { create :user }
        let!(:message) { create :group_message, owner: user }
        
        subject { message.owner_name }
        
        it 'returns correct name' do
            expect(subject).to include(user.first_name)
            expect(subject).to include(user.last_name)
        end
    end
    
    describe "#news_feed_link" do
        it "has default news_feed_link" do
            group_message = create(:group_message)
            expect(group_message.news_feed_link).to_not be_nil
        end
    end
    
    describe "#remove_segment_association" do
        it "removes segment association" do
            group_message = create(:group_message)
            segment = create(:segment)
            
            group_message.segment_ids = [segment.id]
            group_message.save
            
            expect(group_message.segments.length).to eq(1)
            expect(group_message.group_messages_segments.length).to eq(1)
            
            group_messages_segment = group_message.group_messages_segments.where(:segment_id => segment.id).first
            
            expect(group_messages_segment.news_feed_link_segment).to_not be(nil)
            
            group_message.remove_segment_association(segment)
            
            expect(group_messages_segment.news_feed_link_segment).to_not be(nil)
            
        end
    end
end
