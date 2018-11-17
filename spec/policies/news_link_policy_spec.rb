require 'rails_helper'

RSpec.describe NewsLinkPolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:news_link){ create(:news_link, author: user) }

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.news_links_index = false
    no_access.policy_group.news_links_create = false
    no_access.policy_group.news_links_manage = false
    no_access.policy_group.save!
  }

  permissions :index?, :create?, :manage?, :update? do
    it 'allows access to user with correct permissions' do
      expect(subject).to permit(user, news_link)
    end

    it 'denies access to user with incorrect permissions' do
      expect(subject).to_not permit(no_access, news_link)
    end
  end

  permissions :index?, :create?, :update? do
    it 'allows access to non managers' do
      user.policy_group.news_links_manage = false

      expect(subject).to permit(user, news_link)
    end
  end

end
