require 'rails_helper'

RSpec.describe EnterprisePolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }

  subject { EnterprisePolicy.new(user.reload, enterprise) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.enterprise_manage = false
    no_access.policy_group.sso_manage = false
    no_access.policy_group.diversity_manage = false
    no_access.policy_group.branding_manage = false
    no_access.policy_group.manage_posts = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when enterprise_manage is true' do
        before { user.policy_group.update enterprise_manage: true }
        it { is_expected.to permit_action(:update) }
      end

      context 'user has basic group leader permission for enterprise_manage' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update enterprise_manage: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_action(:update) }
      end

      context 'when sso_manage is true' do
        before { user.policy_group.update sso_manage: true }
        it { is_expected.to permit_actions([:edit_auth, :edit_fields, :edit_mobile_fields]) }
      end

      context 'user has basic group leader permission for sso_manage' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update sso_manage: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:edit_auth, :edit_fields, :edit_mobile_fields]) }
      end

      context 'when branding_manage is true' do
        before { user.policy_group.update branding_manage: true }
        it { is_expected.to permit_actions([:edit_branding, :update_branding, :restore_default_branding]) }
      end

      context 'user has basic group leader permission for branding_manage' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update branding_manage: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:edit_branding, :update_branding, :restore_default_branding]) }
      end
    end

    context 'when manage_all is true'
  end

  describe 'for users with no access'

  describe 'custom policies' do
    context '#manage_branding?' do
      context 'when branding_manage is true' do
        before { user.policy_group.update branding_manage: true }

        it 'returns true' do
          expect(subject.manage_branding?).to be(true)
        end
      end

      context 'user has basic group leader permission for branding_manage' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update branding_manage: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end


        it 'returns true' do
          expect(subject.manage_branding?).to be(true)
        end
      end

      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.manage_branding?).to be(true)
        end
      end
    end

    context '#manage_posts?' do
      context 'when manage_posts is true' do
        before { user.policy_group.update manage_posts: true }

        it 'returns true' do
          expect(subject.manage_posts?).to be(true)
        end
      end

      context 'user has basic group leader permission for manage_posts' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update manage_posts: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end


        it 'returns true' do
          expect(subject.manage_posts?).to be(true)
        end
      end

      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.manage_posts?).to be(true)
        end
      end
    end

    context '#manage_permissions?' do
      context 'when permissions_manage is true' do
        before { user.policy_group.update permissions_manage: true }

        it 'returns true' do
          expect(subject.manage_permissions?).to be(true)
        end
      end

      context 'user has basic group leader permission for permissions_manage' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update permissions_manage: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end


        it 'returns true' do
          expect(subject.manage_permissions?).to be(true)
        end
      end

      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.manage_permissions?).to be(true)
        end
      end
    end

    context '#sso_manage?' do
      context 'when branding_manage is true' do
        before { user.policy_group.update sso_manage: true }

        it 'returns true' do
          expect(subject.sso_manage?).to be(true)
        end
      end

      context 'user has basic group leader permission for sso_manage' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update sso_manage: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end


        it 'returns true' do
          expect(subject.sso_manage?).to be(true)
        end
      end

      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.sso_manage?).to be(true)
        end
      end
    end

    context '#diversity_manage?' do
      context 'when diversity_manage is true' do
        before { user.policy_group.update diversity_manage: true }

        it 'returns true' do
          expect(subject.diversity_manage?).to be(true)
        end
      end

      context 'user has basic group leader permission for diversity_manage' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update diversity_manage: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end


        it 'returns true' do
          expect(subject.diversity_manage?).to be(true)
        end
      end

      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.diversity_manage?).to be(true)
        end
      end
    end

    context '#edit_pending_comments?' do
      context 'when manage_posts is true' do
        before { user.policy_group.update manage_posts: true }

        it 'returns true' do
          expect(subject.edit_pending_comments?).to be(true)
        end
      end

      context 'user has basic group leader permission for manage_posts' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update manage_posts: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end


        it 'returns true' do
          expect(subject.edit_pending_comments?).to be(true)
        end
      end

      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.edit_pending_comments?).to be(true)
        end
      end
    end

    context '#enterprise_manage?' do
      context 'when enterprise_manage is true' do
        before { user.policy_group.update enterprise_manage: true }

        it 'returns true' do
          expect(subject.enterprise_manage?).to be(true)
        end
      end

      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.enterprise_manage?).to be(true)
        end
      end
    end
  end
end
