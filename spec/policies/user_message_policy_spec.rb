require 'rails_helper'

RSpec.describe UserMessagePolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:group_message) { create(:group_message, author: user) }

  subject { UserMessagePolicy.new(user.reload, group_message) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.group_messages_index = false
    no_access.policy_group.group_messages_create = false
    no_access.policy_group.group_messages_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      it { is_expected.to permit_actions([:update, :destroy]) }
    end

    context 'user has basic group leader permission, group_messages_index is true and current user is not author' do
      before do
        group_message.author = create(:user)
        user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
        user_role.policy_group_template.update group_messages_index: true
        group = create(:group, enterprise: enterprise)
        create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                              user_role_id: user_role.id)
      end

      it { is_expected.to permit_actions([:index, :show]) }
    end

    context 'group_message_index is true and current user IS NOT author' do
      before do
        group_message.author = create(:user)
        user.policy_group.update group_messages_index: true
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

    context 'user has basic group leader permission, group_messages_create is true and current user is not author' do
      before do
        group_message.author = create(:user)
        user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
        user_role.policy_group_template.update group_messages_create: true
        group = create(:group, enterprise: enterprise)
        create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                              user_role_id: user_role.id)
      end

      it { is_expected.to permit_actions([:index, :show, :create]) }
    end

    context 'group_messages_manage is true and current user IS NOT author' do
      before do
        group_message.author = create(:user)
        user.policy_group.update group_messages_manage: true
      end

      it { is_expected.to permit_actions([:index, :show, :create, :update, :destroy]) }
    end

    context 'user has basic group leader permission, group_messages_manage is true and current user IS NOT author' do
      before do
        group_message.author = create(:user)
        user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
        user_role.policy_group_template.update group_messages_manage: true
        group = create(:group, enterprise: enterprise)
        create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                              user_role_id: user_role.id)
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
