require 'rails_helper'

RSpec.describe SocialLinkPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:social_link) { create(:social_link, author: user) }
  let(:noshow_social_link) { create(:social_link, author: create(:user)) }
  let(:policy_scope) { SocialLinkPolicy::Scope.new(user, SocialLink).resolve }

  subject { SocialLinkPolicy.new(user.reload, social_link) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.social_links_index = false
    no_access.policy_group.social_links_create = false
    no_access.policy_group.social_links_manage = false
    no_access.policy_group.save!
  }


  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'user with basic group leader permission, social_links_index is true and current user IS NOT owner' do
        before do
          social_link.author = create(:user)
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update social_links_index: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_action(:index) }
      end

      context 'when social_links_index is true' do
        before do
          social_link.author = create(:user)
          user.policy_group.update social_links_index: true
        end

        it { is_expected.to permit_action(:index) }
      end

      context 'user with basic group leader permission, social_links_create, and current user IS NOT author' do
        before do
          social_link.author = create(:user)
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update social_links_create: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_action(:create) }
      end

      context 'when social_links_create is true' do
        before do
          social_link.author = create(:user)
          user.policy_group.update social_links_create: true
        end

        it { is_expected.to permit_action(:create) }
      end

      context 'no social_link permissions, current user IS author' do
        it { is_expected.to permit_actions([:update, :destroy]) }
      end

      context 'no social_link permissions, current user IS NOT author' do
        before { social_link.author = create(:user) }
        it { is_expected.to forbid_actions([:index, :create, :update, :destroy]) }
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      context 'social_links_index, social_links_create, and social_links_manage are false, current user IS NOT author' do
        before { social_link.author = create(:user) }

        it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
      end

      context 'user with basic group leader permission, social_links_manage, and current user IS NOT author' do
        before do
          social_link.author = create(:user)
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update social_links_manage: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
      end

      context 'when social_links_manage is true' do
        before do
          social_link.author = create(:user)
          user.policy_group.update social_links_manage: true
        end

        it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
      end
    end
  end

  describe 'for users with no access' do
    let(:user) { no_access }
    let(:social_link) { create(:social_link, author: create(:user)) }
    it { is_expected.to forbid_actions([:index, :create, :update, :destroy]) }
  end

  permissions '.scope' do
    context 'when manage all is true' do
      before do
        user.policy_group.update manage_all: true
        social_link
      end

      it 'only shows social_links belonging to user' do
        expect(policy_scope).to include(social_link)
        expect(policy_scope).to_not include(noshow_social_link)
      end
    end

    context 'when social_links_manage is true' do
      before do
        user.policy_group.update social_links_manage: true
        social_link
      end

      it 'only shows social_links belonging to user' do
        expect(policy_scope).to include(social_link)
        expect(policy_scope).to_not include(noshow_social_link)
      end
    end
  end
end
