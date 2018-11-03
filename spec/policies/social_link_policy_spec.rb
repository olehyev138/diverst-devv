require 'rails_helper'

RSpec.describe SocialLinkPolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:social_link){ create(:social_link, author: user) }
  let(:noshow_social_link) { create(:social_link, author: no_access) }
  let(:policy_scope) { SocialLinkPolicy::Scope.new(user, SocialLink).resolve }

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.social_links_index = false
    no_access.policy_group.social_links_create = false
    no_access.policy_group.social_links_manage = false
    no_access.policy_group.save!
  }

  permissions :index?, :create?, :manage?, :update? do
    it 'allows access to user with correct permissions' do
      expect(subject).to permit(user, social_link)
    end

    it 'denies access to user with incorrect permissions' do
      expect(subject).to_not permit(no_access, social_link)
    end
  end

  permissions :index?, :create?, :update? do
    it 'allows access to non managers' do
      user.policy_group.social_links_manage = false

      expect(subject).to permit(user, social_link)
    end
  end

  permissions '.scope' do

    before { social_link } # trigger lazy let

    it 'only shows social_links belonging to user' do
      expect(policy_scope).to include(social_link)
      expect(policy_scope).to_not include(noshow_social_link)
    end
  end
end
