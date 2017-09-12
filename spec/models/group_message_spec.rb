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
end
