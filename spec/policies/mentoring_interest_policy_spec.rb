require 'rails_helper'

RSpec.describe MentoringInterestPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:mentoring_interest) { create(:mentoring_interest, enterprise_id: enterprise.id) }

  subject { MentoringInterestPolicy.new(user.reload, mentoring_interest) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.mentorship_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'user has basic group leader permission for mentorship_manage' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update mentorship_manage: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:index, :create, :edit, :update, :destroy]) }
      end

      context 'when mentorship_manage is true' do
        before { user.policy_group.update mentorship_manage: true }
        it { is_expected.to permit_actions([:index, :create, :edit, :update, :destroy]) }
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }
      it { is_expected.to permit_actions([:index, :create, :edit, :update, :destroy]) }
    end
  end

  describe 'for users with no access' do
    it { is_expected.to forbid_actions([:index, :edit, :create, :update, :destroy]) }
  end
end
