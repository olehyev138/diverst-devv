require 'rails_helper'

RSpec.describe UserReward do
  describe "when validating" do
    let(:user_reward){ build_stubbed(:user_reward) }

    it { expect(user_reward).to validate_presence_of(:user) }
    it { expect(user_reward).to validate_presence_of(:reward) }
    it { expect(user_reward).to validate_presence_of(:points) }
    it { expect(user_reward).to validate_numericality_of(:points).only_integer }
    it { expect(user_reward).to belong_to(:user) }
    it { expect(user_reward).to belong_to(:reward) }
  end
end
