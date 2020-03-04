require 'rails_helper'

RSpec.describe GroupNewsLinkPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:group) { create :group, enterprise: enterprise }
  let(:news_link) { create(:news_link, group: group, author: user) }

  subject { GroupNewsLinkPolicy.new(user.reload, [group, news_link]) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.news_links_index = false
    no_access.policy_group.news_links_create = false
    no_access.policy_group.news_links_manage = false
    no_access.policy_group.group_posts_index = false
    no_access.policy_group.manage_posts = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when group.latest_news_visibility is public' do
        before { group.latest_news_visibility = 'public' }

        context 'when current user IS NOT author' do
          before { news_link.author = create(:user) }

          context 'when ONLY manage_posts is true' do
            before { user.policy_group.update manage_posts: true }
            it { is_expected.to permit_action(:index) }
          end

          context 'when ONLY news_links_index is true' do
            before { user.policy_group.update news_links_index: true }
            it { is_expected.to permit_action(:index) }
          end

          context 'user has basic group leader permission for news_links_index' do
            before do
              user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
              user_role.policy_group_template.update news_links_index: true
              group = create(:group, enterprise: enterprise)
              create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                    user_role_id: user_role.id)
            end

            it { is_expected.to permit_action(:index) }
          end

          context 'user has basic group leader permission for manage_posts' do
            before do
              user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
              user_role.policy_group_template.update manage_posts: true
              group = create(:group, enterprise: enterprise)
              create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                    user_role_id: user_role.id)
            end

            it { is_expected.to permit_action(:index) }
          end
        end

        context 'when current user IS author' do
          context 'when manage_posts, news_links_index, news_links_create and news_links_manage are false' do
            it { is_expected.to permit_actions([:edit, :update, :destroy]) }
          end
        end
      end

      context 'group.latest_news_visibility is nil' do
        before { group.latest_news_visibility = '' }

        context 'when author IS NOT current user' do
          before { news_link.author = create(:user) }

          context 'when ONLY news_links_manage and groups_manage are true' do
            before { user.policy_group.update groups_manage: true, news_links_manage: true }
            it { is_expected.to permit_actions([:index, :edit, :update, :destroy]) }
          end

          context 'when ONLY news_links_create and groups_manage are true' do
            before { user.policy_group.update groups_manage: true, news_links_create: true }
            it { is_expected.to permit_action(:index) }
          end

          context 'when ONLY news_links_index and groups_manage are true' do
            before { user.policy_group.update groups_manage: true, news_links_index: true }
            it { is_expected.to permit_action(:index) }
          end
        end
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      context 'when groups_manage, manage_posts, social_links_manage, social_links_create, social_links_index are false' do
        it { is_expected.to permit_actions([:index, :edit, :update, :destroy]) }
      end
    end
  end

  describe 'for users with no access' do
    before { news_link.author = create(:user) }
    it { is_expected.to forbid_actions([:index, :edit, :update, :destroy]) }
  end
end
