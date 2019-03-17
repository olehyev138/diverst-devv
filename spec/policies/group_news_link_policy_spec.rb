require 'rails_helper'

RSpec.describe GroupNewsLinkPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:group) { create :group, enterprise: user.enterprise }
  let(:news_link) { create(:news_link, group: group) }

  subject { GroupNewsLinkPolicy.new(user, [group, news_link]) }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.news_links_index = false
    no_access.policy_group.news_links_create = false
    no_access.policy_group.news_links_manage = false
    no_access.policy_group.group_posts_index = false
    no_access.policy_group.manage_posts = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do 
    context 'allows access when visibility is public and user has index permissions' do 
      let!(:news_link) { nil }
      before { group.latest_news_visibility = 'public' }
      it { is_expected.to  permit_action :index }
    end

    context 'allows access to index, create, update, destroy' do 
      it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
    end
  end

  describe 'for users with no access' do
    let!(:user) { no_access }

    context 'does not allow access when visibility is public and user does not have index permissions' do 
      before { group.latest_news_visibility = 'public' }
      it { is_expected.to forbid_action :index }
    end

    context 'does not allow access to index, create, update, destroy' do 
      it { is_expected.to forbid_actions([:index, :create, :update, :destroy]) }
    end
  end
end
