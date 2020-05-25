require 'rails_helper'

RSpec.describe GroupSocialLinkPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:social_link) { create(:social_link, group: group, author: user) }

  subject { described_class.new(user.reload, [group, social_link]) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.groups_manage = false
    no_access.policy_group.group_posts_index = false
    no_access.policy_group.social_links_create = false
    no_access.policy_group.manage_posts = false
    no_access.policy_group.group_posts_index = false
    no_access.policy_group.manage_posts = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when group.latest_news_visibility is set to public' do
        before { group.latest_news_visibility = 'public' }

        context 'when author IS NOT current user' do
          before { social_link.author = create(:user) }

          context 'when ONLY manage_posts is true' do
            before { user.policy_group.update manage_posts: true }
            it { is_expected.to permit_action(:index) }
          end

          context 'when ONLY group_posts_index is true' do
            before { user.policy_group.update group_posts_index: true }
            it { is_expected.to permit_action(:index) }
          end

          context 'user has basic group leader permission for group_posts_index' do
            before do
              user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
              user_role.policy_group_template.update group_posts_index: true
              create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                    user_role_id: user_role.id)
            end

            it { is_expected.to permit_action(:index) }
          end

          context 'user has basic group leader permission for manage_posts' do
            before do
              user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
              user_role.policy_group_template.update manage_posts: true
              create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                    user_role_id: user_role.id)
            end

            it { is_expected.to permit_action(:index) }
          end
        end

        context 'when author IS current user' do
          context 'when manage_posts, group_posts_index, social_links_create and manage_posts are false' do
            it { is_expected.to permit_actions([:edit, :update, :destroy]) }
          end
        end
      end

      context 'when group.latest_news_visibility is set to sthg other than public' do
        before { group.latest_news_visibility = '' }

        context 'when author IS NOT current user' do
          before { social_link.author = create(:user) }

          context 'when ONLY manage_posts and groups_manage are true' do
            before { user.policy_group.update groups_manage: true, manage_posts: true }
            it { is_expected.to permit_actions([:index, :edit, :update, :destroy]) }
          end

          context 'when ONLY social_links_create and groups_manage are true' do
            before { user.policy_group.update groups_manage: true, social_links_create: true }
            it { is_expected.to permit_action(:index) }
          end

          context 'when ONLY group_posts_index and groups_manage are true' do
            before { user.policy_group.update groups_manage: true, group_posts_index: true }
            it { is_expected.to permit_action(:index) }
          end
        end
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      context 'when groups_manage, manage_posts, manage_posts, social_links_create, group_posts_index are false' do
        it { is_expected.to permit_actions([:index, :edit, :update, :destroy]) }
      end
    end
  end

  describe 'for users with no access' do
    before { social_link.author = create(:user) }
    it { is_expected.to forbid_actions([:index, :edit, :update, :destroy]) }
  end
end
