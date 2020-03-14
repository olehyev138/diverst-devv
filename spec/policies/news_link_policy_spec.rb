require 'rails_helper'

RSpec.describe NewsLinkPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:user) { no_access }
  let(:news_link) { create(:news_link, group: group, author: user) }

  subject { NewsLinkPolicy.new(user.reload, news_link) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.news_links_index = false
    no_access.policy_group.news_links_create = false
    no_access.policy_group.news_links_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when current user IS NOT author' do
        before { news_link.author = create(:user) }

        context 'when news_links_index is true' do
          before { user.policy_group.update news_links_index: true }
          it { is_expected.to permit_actions([:index, :show]) }
        end

        context 'when news_links_create is true' do
          before { user.policy_group.update news_links_create: true }
          it { is_expected.to permit_actions([:index, :show, :create]) }
        end

        context 'when news_links_manage is true' do
          before { user.policy_group.update news_links_manage: true }
          it { is_expected.to permit_actions([:index, :show, :create, :update, :destroy]) }
        end
      end

      context 'when current IS author' do
        it { is_expected.to permit_actions([:update, :destroy]) }
      end
    end

    context 'when manage_all is true' do
      before do
        news_link.author = create(:user)
        user.policy_group.update manage_all: true
      end

      it { is_expected.to permit_actions([:index, :show, :create, :update, :destroy]) }
    end

    context 'when user is a group leader of another group to which news_link belongs' do
      let!(:user_role) { create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3) }

      before do
        news_link.group = create(:group, enterprise: enterprise)
        news_link.author = create(:user, enterprise: enterprise)
        create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                              user_role_id: user_role.id)
      end

      context 'and news_links_index is true' do
        before { user_role.policy_group_template.update news_links_index: true }

        it { is_expected.to forbid_action :index }
      end

      context 'and news_links_create is true' do
        before { user_role.policy_group_template.update news_links_create: true }

        it { is_expected.to forbid_action :create }
      end

      context 'and news_links_manage is true' do
        before { user_role.policy_group_template.update news_links_manage: true }

        it { is_expected.to forbid_actions ([:index, :create, :update, :destroy]) }
      end
    end

    context 'when user is group leader of group to which news_link belongs' do
      let!(:user_role) { create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3) }
      let!(:another_user) { create(:user, enterprise: enterprise) }

      before do
        news_link.author = another_user
        create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                              user_role_id: user_role.id)
      end

      context 'and news_links_index is true' do
        before { user_role.policy_group_template.update news_links_index: true }

        it { is_expected.to permit_actions([:index, :show]) }
        it { is_expected.to forbid_actions([:create, :update, :destroy]) }
      end

      context 'and news_links_create is true' do
        before { user_role.policy_group_template.update news_links_create: true }

        it { is_expected.to permit_actions([:index, :show, :create]) }
        it { is_expected.to forbid_actions([:update, :destroy]) }
      end

      context 'and news_links_manage is true' do
        before { user_role.policy_group_template.update news_links_manage: true }

        it { is_expected.to permit_actions ([:index, :show, :create, :update, :destroy]) }
      end
    end
  end

  describe 'for users with no access' do
    before { news_link.author = create(:user) }
    it { is_expected.to forbid_actions([:index, :show, :create, :update, :destroy]) }
  end

  describe '#manage?' do
    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      it 'returns true' do
        expect(subject.manage?).to be(true)
      end
    end

    context 'when initiatives_manage is true' do
      before { user.policy_group.update news_links_manage: true }

      it 'returns true' do
        expect(subject.manage?).to be(true)
      end
    end
  end
end
