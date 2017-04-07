require 'rails_helper'

RSpec.describe RewardAction do
  describe "when validating" do
    let(:reward_action){ create(:reward_action) }

    it { expect(reward_action).to validate_presence_of(:label) }
    it { expect(reward_action).to validate_presence_of(:key) }
    it { expect(reward_action).to validate_numericality_of(:points).only_integer }
  end
end
