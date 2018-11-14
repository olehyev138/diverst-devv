require 'rails_helper'

RSpec.describe RewardPolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:reward){ create(:reward) }

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.diversity_manage = false
    no_access.policy_group.save!
  }

  permissions :index?, :new?, :create?, :update?, :destroy?, :manage? do
    it 'allows access to user with correct permissions' do
      expect(subject).to permit(user, reward)
    end

    it 'denies access to user with incorrect permissions' do
      expect(subject).to_not permit(no_access, reward)
    end
  end

end
