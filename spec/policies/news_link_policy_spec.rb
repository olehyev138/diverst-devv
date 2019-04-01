require 'rails_helper'

RSpec.describe NewsLinkPolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:news_link){ create(:news_link, author: user) }

  subject { NewsLinkPolicy.new(user, news_link) }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.news_links_index = false
    no_access.policy_group.news_links_create = false
    no_access.policy_group.news_links_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do 
    it { is_expected.to permit_actions([:index, :show, :create, :update, :destroy]) }

    context 'when ONLY manage_all is true' do 
      before { user.policy_group.update news_links_manage: false, news_links_create: false, news_links_index: false, manage_all: true }
      it { is_expected.to permit_actions([:index, :show, :create, :update, :destroy]) }
    end

    context 'when ONLY news_links_index is true' do 
      before { user.policy_group.update news_links_index: true, news_links_create: false, news_links_manage: false, manage_all: false }
      it { is_expected.to permit_actions([:index, :show, :update, :destroy]) }
    end

    context 'when ONLY news_links_index is true and current user is not author' do 
      before do 
        news_link.author = create(:user)
        user.policy_group.update news_links_index: true, news_links_create: false, news_links_manage: false, manage_all: false
      end

      it { is_expected.to permit_actions([:index, :show]) }
    end

    context 'when ONLY news_links_create is true' do 
      before { user.policy_group.update news_links_index: false, news_links_create: true, news_links_manage: false, manage_all: false }
      it { is_expected.to permit_actions([:index, :show, :create, :update, :destroy]) }
    end

    context 'when ONLY news_links_create is true and current user is not author' do 
      before do 
        news_link.author = create(:user)
        user.policy_group.update news_links_index: false, news_links_create: true, news_links_manage: false, manage_all: false
      end

      it { is_expected.to permit_actions([:index, :show, :create]) }
    end

    context 'when ONLY news_links_manage is true' do 
      before { user.policy_group.update news_links_manage: true, news_links_create: false, news_links_index: false, manage_all: false }
      it { is_expected.to permit_actions([:index, :show, :create, :update, :destroy]) }
    end

    context 'when ONLY news_links_manage is true and current user is not author' do 
      before do 
        news_link.author = create(:user)
        user.policy_group.update news_links_manage: true, news_links_create: false, news_links_index: false, manage_all: false
      end

      it { is_expected.to permit_actions([:index, :show, :create]) }
    end
  end

  describe 'for users with no access' do 
    let!(:user) { no_access }
    before { news_link.author = create(:user) }
    it { is_expected.to forbid_actions([:index, :show, :create, :update, :destroy]) }
  end
end
