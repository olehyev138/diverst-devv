require 'rails_helper'

RSpec.describe SocialLink, type: :model do
    
    describe 'validation' do
        let(:social_link) { FactoryGirl.build_stubbed(:social_link) }
        
        it 'has valid factory' do
            expect(social_link).to be_valid
        end

        it{ expect(social_link).to validate_presence_of(:author_id) }
        
        it{ expect(social_link).to have_many(:segments).through(:social_link_segments) }

        it { expect(social_link).to have_one(:news_feed_link)}

        describe 'url population' do
            let(:social_link) { build :social_link, :without_embed_code}

            context 'with correct url' do
                before { social_link.save }

                it 'creates new instance' do
                    expect(social_link).to be_persisted
                    expect(social_link).to be_valid
                end

                it 'populates embed code' do
                    expect(social_link.embed_code).to_not be_empty
                end
            end

            context 'with incorrect url' do
                before do
                    social_link.url = 'https://blahblah.rb/deffdsieh'
                    social_link.save
                end

                it 'does not populate embed code' do
                    expect(social_link.embed_code).to be_nil
                end

                it 'adds error message' do
                    expect(social_link).to_not be_valid
                    expect(social_link.errors[:url]).to include('is not a valid url for supported services')
                end
            end
        end
    end
    
    describe "#after_create" do
        it "calls callbacks and creates attributes/association" do
            social_link = build(:social_link)
            social_link.save
            
            expect(social_link.embed_code).to_not be(nil)
            expect(social_link.news_feed_link).to_not be(nil)
            expect(social_link.url[-1]).to eq("/")
        end
    end
    
    describe "#remove_segment_association" do
        it "removes segment association" do
            social_link = create(:social_link)
            segment = create(:segment)
            
            social_link.segment_ids = [segment.id]
            social_link.save
            
            expect(social_link.segments.length).to eq(1)
            expect(social_link.social_link_segments.length).to eq(1)
            
            social_link_segment = social_link.social_link_segments.where(:segment_id => segment.id).first
            
            expect(social_link_segment.news_feed_link_segment).to_not be(nil)
            
            social_link.remove_segment_association(segment)
            
            expect(social_link_segment.news_feed_link_segment).to_not be(nil)
            
        end
    end
end
