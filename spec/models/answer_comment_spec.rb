require 'rails_helper'

RSpec.describe AnswerComment, type: :model do
  describe 'when validating' do
    let(:answer_comment) { build(:answer_comment) }

    it { expect(answer_comment).to belong_to(:author).class_name('User').inverse_of(:answers).counter_cache(:answer_comments_count) }
    it { expect(answer_comment).to belong_to(:answer).inverse_of(:comments) }
    it { expect(answer_comment).to have_many(:user_reward_actions) }

    it { expect(answer_comment).to validate_length_of(:content).is_at_most(65535) }
    it { expect(answer_comment).to validate_presence_of(:author) }
    it { expect(answer_comment).to validate_presence_of(:answer) }
    it { expect(answer_comment).to validate_presence_of(:content) }
  end

  describe '.unapproved' do
    it 'returns the answer_comments that have not been approved' do
      create_list(:answer_comment, 2, approved: false)
      expect(AnswerComment.unapproved.count).to eq(2)
    end
  end
end
