require 'rails_helper'

RSpec.describe InitiativeCommentPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:initiative_comment) { create(:initiative_comment) }
  let!(:group) { initiative_comment.initiative.owner_group }

  subject { described_class.new(user, [group, initiative_comment]) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.manage_posts = false
    no_access.policy_group.save!
  }

  context 'for users with access' do
    context 'when manage_all is false' do
      context 'when manage_posts is true' do
        before { user.policy_group.update manage_posts: true }
        it { is_expected.to permit_actions([:destroy]) }
      end

      context 'user has basic group leader permission for manage_posts' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update manage_posts: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:destroy]) }
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }
      it { is_expected.to permit_actions([:destroy]) }
    end
  end

  context 'for users with no access' do
    it { is_expected.to forbid_actions([:destroy]) }
  end
end
