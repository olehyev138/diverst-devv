require 'rails_helper'

RSpec.describe NewsLinkHelper do
  let!(:news_link) { create(:news_link) }

  describe '#news_link_picture' do
    it 'returns image_tag when author is present' do
      expect(news_link_picture(news_link)).to eq image_tag(news_link.author.avatar.expiring_url(3600, :thumb), width: '75%')
    end

    it 'return missing user image when author is absent' do
      news_link.author.destroy
      expect(news_link_picture(news_link)).to eq image_tag('/assets/missing_user.png', width: '75%')
    end
  end
end
