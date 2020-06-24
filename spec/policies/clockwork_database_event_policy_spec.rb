require 'rails_helper'

RSpec.describe ClockworkDatabaseEventPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }

  subject { ClockworkDatabaseEventPolicy.new(user.reload, Clockwork) }

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
      context 'update?' do
      end
    end

    context 'when manage_all is true' do
      context 'update?' do
        before { user.policy_group.update manage_all: true }
        it { is_expected.to permit_action(:update) }
      end
    end
  end

  describe 'for users without access' do
    context 'when user has basic group leader permission for enterprise_manage : ' do
      before do
        user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
        user_role.policy_group_template.update enterprise_manage: true
        group = create(:group, enterprise: enterprise)
        create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                              user_role_id: user_role.id)
      end
      it { is_expected.to forbid_action(:update) }
    end
  end
end
