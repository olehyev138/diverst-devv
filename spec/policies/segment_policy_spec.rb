require 'rails_helper'

RSpec.describe SegmentPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:enterprise_2) { create(:enterprise, scope_module_enabled: false) }
  let(:segment) { create(:segment, enterprise: enterprise) }
  let(:segments) { create_list(:segment, 10, enterprise: enterprise2) }
  let(:policy_scope) { SegmentPolicy::Scope.new(user, Segment).resolve }

  subject { SegmentPolicy.new(user.reload, segment) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.segments_index = false
    no_access.policy_group.segments_create = false
    no_access.policy_group.segments_manage = false
    no_access.policy_group.save!
  }

  permissions '.scope' do
    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      it 'shows only segments belonging to enterprise' do
        expect(policy_scope).to eq [segment]
      end
    end
  end

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when segments_index is true' do
        before { user.policy_group.update segments_index: true }

        it { is_expected.to permit_actions([:index, :enterprise_segments]) }
      end

      context 'user has basic group leader permission for segments_index' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update segments_index: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:index, :enterprise_segments]) }
      end

      context 'user has basic group leader permission for segments_manage' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update segments_manage: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:index, :create, :update, :destroy, :enterprise_segments]) }
      end

      context 'when segments_manage is true' do
        before { user.policy_group.update segments_manage: true }
        it { is_expected.to permit_actions([:index, :create, :update, :destroy, :enterprise_segments]) }
      end

      context 'when segments_create is true' do
        before { user.policy_group.update segments_create: true }
        it { is_expected.to permit_actions([:index, :create, :enterprise_segments]) }
      end

      context 'user has basic group leader permission for segments_create' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update segments_create: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:index, :create, :enterprise_segments]) }
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }
      it { is_expected.to permit_actions([:index, :create, :update, :destroy, :enterprise_segments]) }
    end
  end

  describe 'for users with no access' do
    let!(:user) { no_access }
    it { is_expected.to forbid_actions([:index, :create, :update, :destroy, :enterprise_segments]) }
  end

  describe '#manage?' do
    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      it 'returns true' do
        expect(subject.manage?).to be(true)
      end
    end

    context 'user has basic group leader permission for segments_manage' do
      before do
        user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
        user_role.policy_group_template.update segments_manage: true
        group = create(:group, enterprise: enterprise)
        create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                              user_role_id: user_role.id)
      end

      it 'returns true' do
        expect(subject.manage?).to be(true)
      end
    end
  end
end
