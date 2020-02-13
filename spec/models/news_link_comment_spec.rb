require 'rails_helper'

RSpec.describe NewsLinkComment, type: :model do
  describe 'test associations and validations' do
    let(:news_link_comment) { build_stubbed(:news_link_comment) }

    it { expect(news_link_comment).to belong_to(:author).class_name('User') }
    it { expect(news_link_comment).to belong_to(:news_link) }
    it { expect(news_link_comment).to have_many(:user_reward_actions) }

    it { expect(news_link_comment).to validate_presence_of(:author) }
    it { expect(news_link_comment).to validate_presence_of(:news_link) }
    it { expect(news_link_comment).to validate_presence_of(:content) }
    it { expect(news_link_comment).to validate_length_of(:content).is_at_most(65535) }
  end

  describe '.unapproved' do
    it 'returns the news_link_comments that have not been approved' do
      create_list(:news_link_comment, 2, approved: false)
      expect(described_class.unapproved.count).to eq(2)
    end
  end

  describe '.approved' do
    it 'returns approved news_link_comments' do
      create_list(:news_link_comment, 2, approved: true)
      expect(described_class.approved.count).to eq(2)
    end
  end

  describe '#group' do
    let(:news_link_comment) { build(:news_link_comment) }

    it 'returns group' do
      expect(news_link_comment.group).to eq(news_link_comment.news_link.group)
    end
  end
end
