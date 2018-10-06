require 'rails_helper'

RSpec.describe NewsLinkComment, type: :model do
  describe 'when validating' do
    let(:news_link_comment) { build_stubbed(:news_link_comment) }

    it { expect(news_link_comment).to belong_to(:author).class_name('User') }
    it { expect(news_link_comment).to belong_to(:news_link) }
    it { expect(news_link_comment).to validate_presence_of(:author) }
    it { expect(news_link_comment).to validate_presence_of(:news_link) }
    it { expect(news_link_comment).to validate_presence_of(:content) }
  end

  describe "#unapproved" do
    it "returns the news_link_comments that have not been approved" do
      create_list(:news_link_comment, 2, :approved => false)
      expect(NewsLinkComment.unapproved.count).to eq(2)
    end
  end
end
