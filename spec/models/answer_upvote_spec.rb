require 'rails_helper'

RSpec.describe AnswerUpvote, type: :model do
  describe 'when validating' do
    let(:answer_upvote) { build(:answer_upvote) }

    it { expect(answer_upvote).to belong_to(:answer).counter_cache(:upvote_count) }
    it { expect(answer_upvote).to belong_to(:user).with_foreign_key(:author_id) }

    it { expect(answer_upvote).to have_many(:user_reward_actions) }
  end
end
