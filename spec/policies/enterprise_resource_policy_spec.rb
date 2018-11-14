require 'rails_helper'

RSpec.describe EnterpriseResourcePolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.enterprise_resources_index = false
    no_access.policy_group.enterprise_resources_create = false
    no_access.policy_group.enterprise_resources_manage = false
    no_access.policy_group.save!
  }

  permissions :index?, :create?, :update?, :destroy? do
    it 'allows access to user with correct permissions' do
      expect(subject).to permit(user, nil)
    end

    it 'denies access to user with incorrect permissions' do
      expect(subject).to_not permit(no_access, nil)
    end
  end

  permissions :index?, :create? do
    it 'allows access to user with create permissions' do
      user.policy_group.enterprise_resources_manage = false

      expect(subject).to permit(user, nil)
    end
  end

  permissions :index? do
    it 'allows access to user with index permissions' do
      user.policy_group.enterprise_resources_manage = false
      user.policy_group.enterprise_resources_create = false

      expect(subject).to permit(user, nil)
    end
  end
end
