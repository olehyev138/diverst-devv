require 'rails_helper'

RSpec.describe ExpensePolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:expense) { create(:expense, enterprise: enterprise) }

  subject { ExpensePolicy.new(user, expense) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.campaigns_index = false
    no_access.policy_group.campaigns_create = false
    no_access.policy_group.campaigns_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when campaigns_manage is true' do
        before { user.policy_group.update campaigns_manage: true }
        it { is_expected.to permit_actions([:index, :new, :create, :update, :destroy]) }
      end

      context 'user has group leader permission for campaigns_manage' do
        before do
          group = create(:group, enterprise: enterprise)
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update campaigns_manage: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:index, :new, :create, :update, :destroy]) }
      end

      context 'when enterprise.collaborate_module_enabled is true' do
        before { enterprise.update collaborate_module_enabled: true }
        it { is_expected.to forbid_actions([:index, :new, :create, :update, :destroy]) }
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }
      it { is_expected.to permit_actions([:index, :new, :create, :update, :destroy]) }
    end
  end

  describe 'for users with no access' do
    it { is_expected.to forbid_actions([:index, :new, :create, :update, :destroy]) }
  end
end
