require 'rails_helper'

RSpec.describe GroupNewsLinkPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:group) { create :group, enterprise: user.enterprise }
  let(:news_link) { create(:news_link, group: group) }

  subject { described_class }

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

  permissions :index? do

    it 'allows access when visibility is public and user has index permissions' do
      group.latest_news_visibility = 'public'

      expect(subject).to permit(user, [group, nil])
    end

    it 'denies access when visibility is public and user doesnt have index permissions' do
      group.latest_news_visibility = 'public'

      expect(subject).to_not permit(no_access, [group, nil])
    end
  end

  permissions :index?, :create?, :update?, :destroy? do


    it "allows access" do
      expect(subject).to permit(user, [news_link.group, news_link])
    end

    it "doesn't allow access" do
      expect(subject).to_not permit(no_access, [news_link.group, news_link])
    end
  end
end
