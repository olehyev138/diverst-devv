require 'rails_helper'

RSpec.describe CampaignPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:campaign) { create(:campaign, enterprise: enterprise) }
  let(:segments) { create_list(:segment, 10, enterprise: enterprise2) }
  let(:policy_scope) { CampaignPolicy::Scope.new(user, Campaign).resolve }

  subject { CampaignPolicy.new(user, campaign) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.campaigns_index = false
    no_access.policy_group.campaigns_create = false
    no_access.policy_group.campaigns_manage = false
    no_access.policy_group.save!
  }

  permissions '.scope' do
    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      it 'shows only campaigns belonging to enterprise' do
        expect(policy_scope).to eq [campaign]
      end
    end
  end

  context 'for users with access' do
    context 'when  manage_all is false' do
      context 'when current user IS NOT owner' do
        before { campaign.owner = create(:user) }

        context 'when campaigns_index is true' do
          before { user.policy_group.update campaigns_index: true }
          it { is_expected.to permit_action(:index) }
        end

        context 'user has group leader permission for campaigns_index' do
          before do
            group = create(:group, enterprise: enterprise)
            user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update campaigns_index: true
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
              user_role_id: user_role.id)
          end

          it { is_expected.to permit_action(:index) }
        end

        context 'when campaigns_create is true' do
          before { user.policy_group.update campaigns_create: true }
          it { is_expected.to permit_actions([:index, :new, :create]) }
        end

        context 'user has group leader permission for campaigns_create' do
          before do
            group = create(:group, enterprise: enterprise)
            user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update campaigns_create: true
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
              user_role_id: user_role.id)
          end

          it { is_expected.to permit_actions([:index, :new, :create]) }
        end

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
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      it { is_expected.to permit_actions([:index, :new, :create, :update, :destroy]) }

      context 'when collaborate_module_enabled? returns true' do
        before { enterprise.update collaborate_module_enabled: false }

        it { is_expected.to forbid_actions([:index, :new, :create, :update, :destroy]) }
      end
    end
  end

  context 'for users with no access' do
    it { is_expected.to forbid_actions([:index, :new, :create, :update, :destroy]) }
  end

  describe '#manage?' do
      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.manage?).to be(true)
        end
      end

      context 'user has basic group leader permission for campaigns_manage' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update campaigns_manage: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
            user_role_id: user_role.id)
        end

        it 'returns true' do
          expect(subject.manage?).to be(true)
        end
      end

      context 'when campaigns_manage is true' do
        before { user.policy_group.update campaigns_manage: true }

        it 'returns true' do
          expect(subject.manage?).to be(true)
        end
      end
    end
end
