require 'rails_helper'

RSpec.describe OutcomePolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:outcome) { create(:outcome) }

  subject { described_class }

  before {
    outcome.group = create(:group, :owner => user, :enterprise_id => user.enterprise_id)

    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.initiatives_index = false
    no_access.policy_group.initiatives_create = false
    no_access.policy_group.initiatives_manage = false
    no_access.policy_group.save!
  }

  permissions :index?, :create?, :manage?, :update?, :destroy? do
    it 'allows access to user with correct permissions' do
      expect(subject).to permit(user, outcome)
    end

    it 'denies access to user with incorrect permissions' do
      expect(subject).to_not permit(no_access, outcome)
    end
  end

  permissions :index?, :create?, :update?, :destroy?  do
    it 'allows access to non managers' do
      user.policy_group.initiatives_manage = false

      expect(subject).to permit(user, outcome)
    end
  end
end
