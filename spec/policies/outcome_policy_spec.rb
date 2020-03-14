require 'rails_helper'

RSpec.describe OutcomePolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:outcome) { create(:outcome) }

  subject { OutcomePolicy.new(user.reload, outcome) }

  before {
    outcome.group = create(:group, owner: user, enterprise_id: user.enterprise_id)

    no_access.policy_group.manage_all = false
    no_access.policy_group.initiatives_index = false
    no_access.policy_group.initiatives_create = false
    no_access.policy_group.initiatives_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when current user IS NOT group owner' do
        before { outcome.group.owner = create(:user) }

        context 'when initiatives_index is true' do
          before { user.policy_group.update initiatives_index: true }
          it { is_expected.to permit_action(:index) }
        end

        context 'user has basic group leader permission for initiatives_index' do
          before do
            user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update initiatives_index: true
            group = create(:group, enterprise: enterprise)
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it { is_expected.to permit_action(:index) }
        end

        context 'user has basic group leader permission for initiatives_create' do
          before do
            user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update initiatives_create: true
            group = create(:group, enterprise: enterprise)
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it { is_expected.to permit_actions([:index, :create]) }
        end

        context 'when initiatives_create is true' do
          before { user.policy_group.update initiatives_create: true }
          it { is_expected.to permit_actions([:index, :create]) }
        end

        context 'user has basic group leader permission for initiatives_manage' do
          before do
            user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update initiatives_manage: true
            group = create(:group, enterprise: enterprise)
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
        end

        context 'when initiatives_manage is true' do
          before { user.policy_group.update initiatives_manage: true }
          it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
        end
      end

      context 'when current user IS group owner' do
        it { is_expected.to permit_actions([:update, :destroy]) }
      end
    end

    context 'when manage_all is true and current IS group owner' do
      before do
        outcome.group.owner = create(:user)
        user.policy_group.update manage_all: true
      end

      it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
    end
  end

  describe 'for users with no access' do
    before { outcome.group.owner = create(:user) }
    it { is_expected.to forbid_actions([:index, :create, :update, :destroy]) }
  end

  describe '#manage?' do
    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      it 'returns true' do
        expect(subject.manage?).to be(true)
      end
    end

    context 'user has basic group leader permission for initiatives_manage' do
      before do
        user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
        user_role.policy_group_template.update initiatives_manage: true
        group = create(:group, enterprise: enterprise)
        create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                              user_role_id: user_role.id)
      end

      it 'returns true' do
        expect(subject.manage?).to be(true)
      end
    end

    context 'when initiatives_manage is true' do
      before { user.policy_group.update initiatives_manage: true }

      it 'returns true' do
        expect(subject.manage?).to be(true)
      end
    end
  end
end
