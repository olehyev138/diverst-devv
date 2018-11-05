require 'rails_helper'

RSpec.describe GroupSocialLinkPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:group){ create(:group, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:social_link){ create(:social_link, :enterprise => enterprise) }

  subject { described_class }

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
end
