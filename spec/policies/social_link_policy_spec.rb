require 'rails_helper'

RSpec.describe SocialLinkPolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:social_link){ create(:social_link, author: user) }
  let(:noshow_social_link) { create(:social_link, author: no_access) }
  let(:policy_scope) { SocialLinkPolicy::Scope.new(user, SocialLink).resolve }

  subject { SocialLinkPolicy.new(user, social_link) }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.social_links_index = false
    no_access.policy_group.social_links_create = false
    no_access.policy_group.social_links_manage = false
    no_access.policy_group.save!
  }


  describe 'for users with access' do 
    context 'with correct permissions' do 
      it { is_expected.to permit_actions([:index, :create, :update]) }
    end

    context 'who are non managers' do 
      before { user.policy_group.update social_links_manage: false }
      it { is_expected.to permit_actions([:index, :create, :update]) }
    end
  end

  describe 'for users with no access' do 
    let!(:user) { no_access }
    let!(:social_link) { create(:social_link, author: create(:user)) }
    it { is_expected.to forbid_actions([:index, :create, :update, :destroy]) }
  end

  permissions '.scope' do

    before { social_link } # trigger lazy let

    it 'only shows social_links belonging to user' do
      expect(policy_scope).to include(social_link)
      expect(policy_scope).to_not include(noshow_social_link)
    end
  end
end
