require 'rails_helper'

RSpec.describe RewardPolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:reward){ create(:reward) }

  subject { RewardPolicy.new(user, reward) }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.diversity_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do 
    it { is_expected.to permit_actions([:index, :new, :create, :update, :destroy]) }
  end

  describe 'for users with no access' do 
    let!(:user) { no_access }
    it { is_expected.to forbid_actions([:index, :new, :create, :update, :destroy]) }
  end
end
