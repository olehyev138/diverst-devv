require 'rails_helper'

RSpec.describe Rewards::Points::Reporting do
  let(:user) { create(:user) }
  let(:reporting) { Rewards::Points::Reporting.new(user) }

  before :each do
    create(:user_reward_action, user: user, operation: 'add', points: 50)
    create(:user_reward_action, user: user, operation: 'del', points: 20)
    create(:user_reward, user: user, points: 20)
  end

  describe '#user_points' do
    it 'return amount of points of a user' do
      expect(reporting.user_points).to eq 30
    end
  end

  describe '#user_credits' do
    it 'return amount of credits of a user' do
      expect(reporting.user_credits).to eq 10
    end
  end
end
