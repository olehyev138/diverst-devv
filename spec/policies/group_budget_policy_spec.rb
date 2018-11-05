require 'rails_helper'

RSpec.describe GroupBudgetPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:group){ create(:group, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:budget){ create(:budget, :enterprise => enterprise)}

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.groups_budgets_index = false
    no_access.policy_group.groups_budgets_request = false
    no_access.policy_group.groups_budgets_manage = false
    no_access.policy_group.budget_approval = false
    no_access.policy_group.save!
  }

  permissions :approve? do
    it 'should allow user with budget manage permissions' do
      user.policy_group.groups_budgets_manage = true

      expect(subject).to permit(user, [group, nil])
    end

    it 'should allow user with budget approval permissions' do
      user.policy_group.groups_budgets_manage = false
      user.policy_group.budget_approval = true

      expect(subject).to permit(user, [group, nil])
    end

    it 'should deny access to user without correct permissions' do
      expect(subject).to_not permit(no_access, [group, nil])
    end
  end

  permissions :manage_all_budgets? do
    it 'allows access to super admin' do
      user.policy_group.manage_all = true

      expect(subject).to permit(user, [group, nil])
    end

    it 'allows access to users who can manage budgets and groups' do
      user.policy_group.groups_budgets_manage = true
      user.policy_group.groups_manage = true

      expect(subject).to permit(user, [group, nil])
    end

    it 'denies access to users who cant manage budgets' do
      user.policy_group.groups_budgets_manage = false
      user.policy_group.groups_manage = true

      expect(subject).to_not permit(user, [group, nil])
    end

    it 'denies access to users who cant manage groups' do
      user.policy_group.groups_budgets_manage = true
      user.policy_group.groups_manage = false

      expect(subject).to_not permit(user, [group, nil])
    end

    it 'denies access to users who cant manage budgets or groups' do
      expect(subject).to_not permit(no_access, [group, nil])
    end
  end
end
