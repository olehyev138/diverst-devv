require 'rails_helper'

RSpec.describe GroupBasePolicy, :type => :policy do

  let(:user) { create(:user) }
  let(:no_access) { create(:user) }
  let(:group) { create(:group, :owner => user, :enterprise_id => user.enterprise_id)}

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.groups_index = false
    no_access.policy_group.groups_create = false
    no_access.policy_group.groups_manage = false
    no_access.policy_group.groups_budgets_index = false
    no_access.policy_group.groups_members_index = false
    no_access.policy_group.groups_budgets_request = false
    no_access.policy_group.budget_approval = false
    no_access.policy_group.global_calendar = false
    no_access.policy_group.save!
  }


  permissions :is_a_member? do

    it "doesnt allow access when user isnt a member" do
      expect(subject).to_not permit(user, [group, nil])
    end

    it "allows access when user is a member" do
      create(:user_group, :user => user, :group => group)
      expect(subject).to permit(user, [group, nil])
    end
  end

  permissions :is_a_guest? do

    it "allows access to non members" do
      expect(subject).to permit(user, [group, nil])
    end

    it "doesnt allow access members" do
      create(:user_group, :user => user, :group => group)
      expect(subject).to_not permit(user, [group, nil])
    end
  end

  permissions :is_a_leader? do

    it "doesnt allow access when user isnt a leader" do
      expect(subject).to_not permit(user, [group, nil])
    end

    it "allows access when user is a leader" do
      create(:group_leader, :user => user, :group => group)
      expect(subject).to permit(user, [group, nil])
    end
  end

  permissions :is_active_member? do

    it "doesnt allow access when user isnt a member at all" do
      expect(subject).to_not permit(user, [group, group])
    end

    it "doesn't allow access when user is a member but has not been accepted" do
      create(:user_group, :user => user, :group => group, :accepted_member => false)
      expect(subject).to_not permit(user, [group, group])
    end

    it "allows access" do
      create(:user_group, :user => user, :group => group, :accepted_member => true)
      expect(subject).to permit(user, [group, group])
    end
  end

  permissions :is_a_pending_member? do

    it "doesnt allow access when user isnt a member at all" do
      expect(subject).to_not permit(user, [group, group])
    end

    it "doesn't allow access when user is a member but has been accepted" do
      create(:user_group, :user => user, :group => group, :accepted_member => true)
      expect(subject).to_not permit(user, [group, group])
    end

    it "allows access to a unaccepted member" do
      create(:user_group, :user => user, :group => group, :accepted_member => false)
      expect(subject).to permit(user, [group, group])
    end
  end

  describe 'has_group_leader_permissions?' do

    it 'doesnt allow access to non leaders' do
      expect(subject.new(user, [group, nil])
        .has_group_leader_permissions?(nil)).to be(false)
    end

    it 'doesnt allow access when user is leader but permission doesnt exist' do
      create(:group_leader, user: user, group: group)

      expect(subject.new(user, [group, nil])
        .has_group_leader_permissions?('silly_permission')).to be(false)
    end

    it 'doesnt allow access when user is leader but permission is false' do
      create(:group_leader, user: user, group: group)

      expect(subject.new(user, [group, nil])
        .has_group_leader_permissions?('groups_budgets_index')).to be(false)
    end

    it 'allows access when user is group leader with correct permissions' do
      # permission used here is irrelevant, simply a boolean value

      user_role =  create(:user_role)
      user_role.policy_group_template.groups_budgets_index = true
      user_role.policy_group_template.save!

      create(:group_leader, user: user, group: group,
        groups_budgets_index: true, user_role: user_role)

      expect(subject.new(user, [group, nil])
        .has_group_leader_permissions?('groups_budgets_index')).to be(true)
    end
  end

  permissions :manage_group_resource, :view_group_resource do
    it 'allows access to super admin' do
      user.policy_group.manage_all = true
      user.policy_group.groups_manage = false

      expect(subject.new(user, [nil, nil])
        .manage_group_resource(nil)).to be(true)
    end

    it 'allows access to group managers' do
      expect(subject.new(user, [nil, nil])
        .manage_group_resource('groups_create')).to be(true)
    end

    it 'allows access to group leaders' do
      user.policy_group.groups_manage = false

      user_role = create(:user_role)
      user_role.policy_group_template.groups_budgets_index = true
      user_role.policy_group_template.save!

      create(:group_leader, user: user, group: group,
        groups_budgets_index: true, user_role: user_role)

      expect(subject.new(user, [group, group])
        .manage_group_resource('groups_budgets_index')).to be(true)
    end

    it 'allows access to group members' do
      user.policy_group.groups_manage = false
      user.policy_group.groups_create = true

      create(:user_group, :user => user, :group => group, :accepted_member => true)

      expect(subject.new(user, [group, group])
        .manage_group_resource('groups_create')).to be(true)
    end

    it 'doesnt allow access if you are group manager but permission isnt true' do
      user.policy_group.groups_create = false

      expect(subject.new(user, [group, group])
        .manage_group_resource('groups_create')).to be(false)
    end

    it 'doesnt allow access if you are member but permission isnt true' do
      user.policy_group.groups_manage = false
      user.policy_group.groups_create = false

      create(:user_group, :user => user, :group => group, :accepted_member => true)

      expect(subject.new(user, [group, group])
        .manage_group_resource('groups_create')).to be(false)
    end

    it 'doesnt allow access if your not a super admin, group manager, leader or member' do
      user.policy_group.groups_manage = false

      expect(subject.new(user, [group, group])
        .manage_group_resource('groups_create')).to be(false)
    end
  end
end
