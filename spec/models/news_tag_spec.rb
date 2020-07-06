require 'rails_helper'

RSpec.describe NewsTag, type: :model do
  describe 'test associations and validations' do
    let(:news_tag) { build(:news_tag) }

    it { expect(news_tag).to have_many(:news_feed_link_tags).with_foreign_key(:news_tag_name) }
    it { expect(news_tag).to have_many(:news_feed_links).through(:news_feed_link_tags) }
    it { expect(news_tag).to validate_uniqueness_of(:name).case_insensitive }
  end
end
