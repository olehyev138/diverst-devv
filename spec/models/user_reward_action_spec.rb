require 'rails_helper'

RSpec.describe UserRewardAction do
  describe "when validating" do
    let(:user_reward_action){ create(:user_reward_action) }

    it { expect(user_reward_action).to validate_presence_of(:user) }
    it { expect(user_reward_action).to validate_presence_of(:reward_action) }
    it { expect(user_reward_action).to belong_to(:user) }
    it { expect(user_reward_action).to belong_to(:reward_action) }
  end
end
