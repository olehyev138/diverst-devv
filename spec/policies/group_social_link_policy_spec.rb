require 'rails_helper'

RSpec.describe GroupSocialLinkPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:group){ create(:group, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:social_link){ create(:social_link, :group => group, :author => user) }

  subject { described_class.new(user, [group, social_link]) }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.social_links_index = false
    no_access.policy_group.social_links_create = false
    no_access.policy_group.social_links_manage = false
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
            before { user.policy_group.update manage_posts: true, social_links_manage: false, social_links_create: false, social_links_index: false }
            it { is_expected.to permit_action(:index) }
          end

          context 'when ONLY social_links_index is true' do 
            before { user.policy_group.update manage_posts: false, social_links_manage: false, social_links_create: false, social_links_index: true }
            it { is_expected.to permit_action(:index) }
          end
        end

        context 'when author IS current user' do 
          context 'when manage_posts, social_links_index, social_links_create and social_links_manage are false' do 
            before { user.policy_group.update manage_posts: false, social_links_manage: false, social_links_create: false, social_links_index: false }
            it { is_expected.to permit_actions([:edit, :update, :destroy]) }
          end
        end
      end

      context 'when group.latest_news_visibility is set to sthg other than public' do 
        before { group.latest_news_visibility = '' }

        context 'when author IS NOT current user' do 
          before { social_link.author = create(:user) }

          context 'when ONLY social_links_manage and groups_manage are true' do 
            before { user.policy_group.update groups_manage: true, manage_posts: false, social_links_index: false, social_links_create: false, social_links_manage: true }
            it { is_expected.to permit_actions([:index, :edit, :update, :destroy]) }
          end

          context 'when ONLY social_links_create and groups_manage are true' do 
            before { user.policy_group.update groups_manage: true, manage_posts: false, social_links_manage: false, social_links_create: true, social_links_index: false }
            it { is_expected.to permit_actions([:index]) }
          end

          context 'when ONLY social_links_index and groups_manage are true' do 
            before { user.policy_group.update groups_manage: true, manage_posts: false, social_links_manage: false, social_links_create: false, social_links_index: true }
            it { is_expected.to permit_action(:index) }
          end
        end
      end
    end  

    context 'when manage_all is true' do 
      before { user.policy_group.update manage_all: true }

      context 'when groups_manage, manage_posts, social_links_manage, social_links_create, social_links_index are false' do 
        before { user.policy_group.update groups_manage: false, manage_posts: false, social_links_manage: false, social_links_create: false, social_links_index: false }
        it { is_expected.to permit_actions([:index, :edit, :update, :destroy]) }
      end
    end
  end

  describe 'for users with no access' do 
    before { social_link.author = create(:user) }
    let!(:user) { no_access }
    it { is_expected.to forbid_actions([:index, :edit, :update, :destroy]) }
  end
end
