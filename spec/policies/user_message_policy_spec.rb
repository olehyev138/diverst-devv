require 'rails_helper'

RSpec.describe UserMessagePolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:group_message) { create(:group_message, group: group, author: user) }

  subject { UserMessagePolicy.new(user.reload, group_message) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.group_posts_index = false
    no_access.policy_group.group_messages_create = false
    no_access.policy_group.manage_posts = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      it { is_expected.to permit_actions([:update, :destroy]) }
    end

    context 'group_message_index is true and current user IS NOT author' do
      before do
        group_message.author = create(:user)
        user.policy_group.update group_posts_index: true
      end

      it { is_expected.to permit_actions([:index, :show]) }
    end

    context 'group_messages_create is true and current user IS NOT author' do
      before do
        group_message.author = create(:user)
        user.policy_group.update group_messages_create: true
      end

      it { is_expected.to permit_actions([:index, :show, :create]) }
    end

    context 'manage_posts is true and current user IS NOT author' do
      before do
        group_message.author = create(:user)
        user.policy_group.update manage_posts: true
      end

      it { is_expected.to permit_actions([:index, :show, :create, :update, :destroy]) }
    end

    context 'no group_message permissions, current user IS author' do
      it { is_expected.to permit_actions([:update, :destroy]) }
    end

    context 'no group_message permissions, current user IS NOT author' do
      before { group_message.author = create(:user) }
      it { is_expected.to forbid_actions([:index, :create, :update, :destroy]) }
    end

    context 'when user is a group leader of another group to which group_message belongs' do
      let!(:user_role) { create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3) }

      before do
        group_message.group = create(:group, enterprise: enterprise)
        group_message.author = create(:user, enterprise: enterprise)
        create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                              user_role_id: user_role.id)
      end

      context 'and group_posts_index is true' do
        before { user_role.policy_group_template.update group_posts_index: true }

        it { is_expected.to forbid_action :index }
      end

      context 'and group_messages_create is true' do
        before { user_role.policy_group_template.update group_messages_create: true }

        it { is_expected.to forbid_action :create }
      end

      context 'and manage_posts is true' do
        before { user_role.policy_group_template.update manage_posts: true }

        it { is_expected.to forbid_actions ([:index, :create, :update, :destroy]) }
      end
    end

    context 'when user is group leader of group to which group_message belongs' do
      let!(:user_role) { create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3) }
      let!(:another_user) { create(:user, enterprise: enterprise) }

      before do
        group_message.author = another_user
        create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                              user_role_id: user_role.id)
      end

      context 'and group_posts_index is true' do
        before { user_role.policy_group_template.update group_posts_index: true }

        it { is_expected.to permit_actions([:index, :show]) }
        it { is_expected.to forbid_actions([:create, :update, :destroy]) }
      end

      context 'and group_messages_create is true' do
        before { user_role.policy_group_template.update group_messages_create: true }

        it { is_expected.to permit_actions([:index, :show, :create]) }
        it { is_expected.to forbid_actions([:update, :destroy]) }
      end

      context 'and manage_posts is true' do
        before { user_role.policy_group_template.update manage_posts: true }

        it { is_expected.to permit_actions ([:index, :show, :create, :update, :destroy]) }
      end
    end
  end

  context 'when manage_all is true' do
    before { user.policy_group.update manage_all: true }
    it { is_expected.to permit_actions([:index, :show, :create, :update, :destroy]) }
  end

  describe 'for users with no access' do
    let!(:user) { no_access }
    before { group_message.author = create(:user) }
    it { is_expected.to forbid_actions([:index, :create, :show, :update, :destroy]) }
  end
end
