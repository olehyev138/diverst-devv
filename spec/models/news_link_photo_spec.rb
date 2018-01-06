require 'rails_helper'

RSpec.describe NewsLinkPhoto, type: :model do
  describe 'when validating' do
    let(:news_link_photo) { build_stubbed(:news_link_photo) }
    it { expect(news_link_photo).to belong_to(:news_link) }
  end
end
