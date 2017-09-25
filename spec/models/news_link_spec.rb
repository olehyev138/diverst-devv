require 'rails_helper'

RSpec.describe NewsLink, type: :model do
    
    describe 'validations' do
        let(:news_link) { FactoryGirl.build_stubbed(:news_link) }

        it{ expect(news_link).to validate_presence_of(:group_id) }
        it{ expect(news_link).to validate_presence_of(:title) }
        it{ expect(news_link).to validate_presence_of(:description) }
        it{ expect(news_link).to validate_presence_of(:author_id) }
        
        it { expect(news_link).to belong_to(:group) }
        it { expect(news_link).to belong_to(:author) }
        
        it{ expect(news_link).to have_many(:segments).through(:news_link_segments) }
        
        it { expect(news_link).to have_many(:comments) }
        it { expect(news_link).to have_one(:news_feed_link)}
    end
    
    describe "#news_feed_link" do
        it "has default news_feed_link" do
            user = create(:user)
            news_link = create(:news_link, :author => user)
            expect(news_link.news_feed_link).to_not be_nil
        end
    end
end
