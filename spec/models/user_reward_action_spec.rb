require 'rails_helper'

RSpec.describe UserRewardAction do
  describe 'when validating' do
    let(:user_reward_action) { build_stubbed(:user_reward_action) }

    it { expect(user_reward_action).to validate_presence_of(:user) }
    it { expect(user_reward_action).to validate_presence_of(:reward_action) }
    it { expect(user_reward_action).to validate_presence_of(:operation) }
    it { expect(user_reward_action).to validate_presence_of(:points) }
    it { expect(user_reward_action).to validate_numericality_of(:points).only_integer }
    it { expect(user_reward_action).to belong_to(:user) }
    it { expect(user_reward_action).to belong_to(:reward_action) }
    it { expect(user_reward_action).to belong_to(:initiative) }
    it { expect(user_reward_action).to belong_to(:initiative_comment) }
    it { expect(user_reward_action).to belong_to(:group_message) }
    it { expect(user_reward_action).to belong_to(:group_message_comment) }
    it { expect(user_reward_action).to belong_to(:news_link) }
    it { expect(user_reward_action).to belong_to(:news_link_comment) }
    it { expect(user_reward_action).to belong_to(:social_link) }
    it { expect(user_reward_action).to belong_to(:answer_comment) }
    it { expect(user_reward_action).to belong_to(:answer_upvote) }
    it { expect(user_reward_action).to belong_to(:answer) }
    it { expect(user_reward_action).to belong_to(:poll_response) }
    it { expect(user_reward_action).to define_enum_for(:operation).with([:add, :del]) }
  end
end
