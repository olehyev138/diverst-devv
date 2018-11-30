require 'rails_helper'

RSpec.describe GroupPolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:group){ create(:group, :owner => user, :enterprise_id => user.enterprise_id)}
  let(:policy_scope) { GroupPolicy::Scope.new(user, Group).resolve }

  subject { described_class }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.groups_index = false
    no_access.policy_group.groups_create = false
    no_access.policy_group.groups_manage = false
    no_access.policy_group.groups_budgets_index = false
    no_access.policy_group.groups_members_index = false
    no_access.policy_group.groups_budgets_request = false
    no_access.policy_group.budget_approval = false
    no_access.policy_group.groups_manage = false
    no_access.policy_group.global_calendar = false
    no_access.policy_group.save!
  }

  permissions ".scope" do
    it "shows only groups belonging to enterprise" do
      expect(policy_scope).to eq [group]
    end
  end

  context "when regular user" do

    permissions :index?, :create? , :update?, :destroy?, :calendar? do

      it "allows access" do
        expect(subject).to permit(user, group)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, group)
      end
    end
  end

  permissions :is_a_leader? do

    it "doesnt allow access" do
      expect(subject).to_not permit(user, group)
    end

    it "allows access" do
      create(:user_group, :user => user, :group => group, :accepted_member => true)
      create(:group_leader, :user => user, :group => group)
      expect(subject).to permit(user, group)
    end
  end

  permissions :is_a_member? do

    it "doesnt allow access" do
      expect(subject).to_not permit(user, group)
    end

    it "allows access" do
      create(:user_group, :user => user, :group => group)
      expect(subject).to permit(user, group)
    end
  end

  permissions :is_a_pending_member? do

    it "doesnt allow access when user isnt a member at all" do
      expect(subject).to_not permit(user, group)
    end

    it "doesn't allow access when user is a member but has been accepted" do
      create(:user_group, :user => user, :group => group, :accepted_member => true)
      expect(subject).to_not permit(user, group)
    end

    it "allows access" do
      create(:user_group, :user => user, :group => group, :accepted_member => false)
      expect(subject).to permit(user, group)
    end
  end

  permissions :is_an_accepted_member? do

    it "doesnt allow access when user isnt a member at all" do
      expect(subject).to_not permit(user, group)
    end

    it "doesn't allow access when user is a member but has not been accepted" do
      create(:user_group, :user => user, :group => group, :accepted_member => false)
      expect(subject).to_not permit(user, group)
    end

    it "allows access" do
      create(:user_group, :user => user, :group => group, :accepted_member => true)
      expect(subject).to permit(user, group)
    end
  end

  context 'when a user manages a group' do

    permissions :manage_all_groups?, :manage_all_group_budgets?, :manage? do

      it 'allows access to a super user' do
        expect(subject).to permit(user, group)
      end

      it 'allows access to a group manager' do
        group_manager = create(:user)
        group_manager.policy_group.manage_all = false
        group_manager.policy_group.groups_manage = true

        expect(subject).to permit(group_manager, group)
      end

      it 'doesnt allow access to a user without permissions' do
        expect(subject).to_not permit(no_access, group)
      end
    end
  end

  permissions :parent_group_permissions? do

    it 'allows access to group with parent with correct permissions' do
      group.parent = create(:group, :owner => user, :enterprise_id => user.enterprise_id)

      expect(subject).to permit(user, group)
    end

    it 'denies access to group without parent' do
      group.parent = nil
      expect(subject).to_not permit(user, group)
    end
  end

  permissions :insights? do

    it 'allows access to group managers' do
      group_manager = create(:user)
      group_manager.policy_group.manage_all = false
      group_manager.policy_group.groups_insights_manage = true
      group_manager.policy_group.groups_manage = true

      expect(subject).to permit(group_manager, group)
    end

    it 'allows access to group leaders' do
      user.policy_group.manage_all = false

      expect(subject).to permit(user, group)
    end

    it 'allows access to group members' do
      create(:user_group, :user => user, :group => group)
      user.policy_group.manage_all = false
      user.policy_group.groups_manage = false

      user.policy_group.groups_insights_manage = true

      expect(subject).to permit(user, group)
    end
  end

  permissions :layouts? do

    it 'allows access to group managers' do
      group_manager = create(:user)
      group_manager.policy_group.manage_all = false
      group_manager.policy_group.groups_layouts_manage = true
      group_manager.policy_group.groups_manage = true

      expect(subject).to permit(group_manager, group)
    end

    it 'allows access to group leaders' do
      user.policy_group.manage_all = false

      expect(subject).to permit(user, group)
    end

    it 'allows access to group members' do
      create(:user_group, :user => user, :group => group)
      user.policy_group.manage_all = false
      user.policy_group.groups_manage = false

      user.policy_group.groups_layouts_manage = true

      expect(subject).to permit(user, group)
    end
  end
end
