require 'rails_helper'

RSpec.describe NewsLinkComment, type: :model do
  describe 'when validating' do
    let(:news_link_comment) { build_stubbed(:news_link_comment) }

    it { expect(news_link_comment).to belong_to(:author) }
    it { expect(news_link_comment).to belong_to(:news_link) }
    it { expect(news_link_comment).to validate_presence_of(:author) }
    it { expect(news_link_comment).to validate_presence_of(:news_link) }
    it { expect(news_link_comment).to validate_presence_of(:content) }
  end
end
