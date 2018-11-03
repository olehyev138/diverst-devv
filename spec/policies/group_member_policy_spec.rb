require 'rails_helper'

RSpec.describe GroupMemberPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:group){ create(:group, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:member){ user }

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.groups_members_index = false
    no_access.policy_group.groups_members_manage = false
    no_access.policy_group.save!
  }

  permissions :view_members? do

    it 'allows access to super admins' do
      user.policy_group.manage_all = true

      expect(subject).to permit(user, [group, nil])
    end

    it 'allows access when visibility is global and user has index permissions' do
      group.members_visibility = 'global'

      expect(subject).to permit(user, [group, nil])
    end

    it 'denies access when visibility is global and user doesnt have index permissions' do
      group.members_visibility = 'global'

      expect(subject).to_not permit(no_access, [group, nil])
    end

    it 'allows access when visibility is group and user has index permissions' do
      group.members_visibility = 'group'

      expect(subject).to permit(user, [group, nil])
    end

    it 'denies access when visibility is group and user doesnt have index permissions' do
      group.members_visibility = 'group'

      expect(subject).to_not permit(no_access, [group, nil])
    end

    it 'allows access when visiblity is managers_only and user has manage permissions' do
      group.members_visibility = 'managers_only'
      user.policy_group.groups_members_manage = true

      expect(subject).to permit(user, [group, nil])
    end

    it 'allows access when visiblity is managers_only and user has index permissions' do
      group.members_visibility = 'managers_only'
      user.policy_group.groups_members_manage = false
      user.policy_group.groups_members_index = true

      expect(subject).to permit(user, [group, nil])
    end

    it 'denies access when visiblity is managers_only and user has no permissions' do
      group.members_visibility = 'managers_only'

      expect(subject).to_not permit(no_access, [group, nil])
    end

    it 'denies access when visiblity is unrecognized' do
      group.members_visibility = nil

      expect(subject).to_not permit(no_access, [group, nil])
    end
  end

  permissions :create?, :destroy? do
    it 'allows creating/destroying record if record is user' do
      expect(subject).to permit(user, [group, member])
    end

    it 'denies creating/destroying record if record is user' do
      expect(subject).to_not permit(no_access, [group, member])
    end
  end
end
