require 'rails_helper'

RSpec.describe NewsLink, type: :model do

    describe 'validations' do
        let(:news_link) { build_stubbed(:news_link) }

        it{ expect(news_link).to validate_presence_of(:group_id) }
        it{ expect(news_link).to validate_presence_of(:title) }
        it{ expect(news_link).to validate_presence_of(:description) }
        it{ expect(news_link).to validate_presence_of(:author_id) }

        it { expect(news_link).to belong_to(:group) }
        it { expect(news_link).to belong_to(:author).class_name('User') }

        it{ expect(news_link).to have_many(:segments).through(:news_link_segments) }

        it { expect(news_link).to have_many(:comments).class_name('NewsLinkComment').dependent(:destroy) }
        it { expect(news_link).to have_many(:photos).class_name('NewsLinkPhoto').dependent(:destroy) }
        it { expect(news_link).to have_many(:news_link_segments).dependent(:destroy) }
        it { expect(news_link).to have_many(:news_link_photos).dependent(:destroy) }
        it { expect(news_link).to have_one(:news_feed_link).dependent(:destroy)}
        it { expect(news_link).to accept_nested_attributes_for(:photos).allow_destroy(true) }
        it { expect(news_link).to have_attached_file(:picture) }
        it { expect(news_link).to validate_attachment_content_type(:picture)
            .allowing('image/png', 'image/jpeg', 'image/jpg')
            .rejecting('text/xml', 'text/plain') }
    end

    describe 'test callbacks' do
        let!(:news_link) { build(:news_link) }

        it '#build_default_link' do
          expect(news_link).to receive(:build_default_link)
          news_link.save
        end
    end

    describe ".of_segments" do
      let(:author){ create(:user) }

      let(:segment1) { build :segment, enterprise: author.enterprise}
      let(:segment2) { build :segment, enterprise: author.enterprise}

      let!(:news_link_without_segment){ create(:news_link, author_id: author.id, segments: []) }
      let!(:news_link_with_segment){ create(:news_link, author_id: author.id, segments: [segment1]) }
      let!(:news_link_with_another_segment){
        create(:news_link, author_id: author.id, segments: [segment2])
      }

      it "returns initiatives that has specific segments or does not have any segment" do
        expect(NewsLink.of_segments([segment1.id])).to match_array([news_link_without_segment, news_link_with_segment])
      end
    end

    describe "#news_feed_link" do
        it "has default news_feed_link" do
            user = create(:user)
            news_link = create(:news_link, :author => user)
            expect(news_link.news_feed_link).to_not be_nil
        end
    end

    describe "#remove_segment_association" do
        it "removes segment association" do
            news_link = create(:news_link)
            segment = create(:segment)

            news_link.segment_ids = [segment.id]
            news_link.save

            expect(news_link.segments.length).to eq(1)
            expect(news_link.news_link_segments.length).to eq(1)

            news_link_segment = news_link.news_link_segments.where(:segment_id => segment.id).first

            expect(news_link_segment.news_feed_link_segment).to_not be(nil)

            news_link.remove_segment_association(segment)

            expect(news_link_segment.news_feed_link_segment).to_not be(nil)

        end
    end
end
