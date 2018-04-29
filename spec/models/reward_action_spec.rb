require 'rails_helper'

RSpec.describe RewardAction do
  describe "when validating" do
    let(:reward_action){ build_stubbed(:reward_action) }

    it { expect(reward_action).to validate_presence_of(:label) }
    it { expect(reward_action).to validate_presence_of(:key) }
    it { expect(reward_action).to validate_numericality_of(:points).is_greater_than_or_equal_to(0).only_integer }
    it { expect(reward_action).to belong_to(:enterprise) }
  end
end
