require 'rails_helper'

RSpec.describe GroupPostsPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:group){ create(:group, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:post){ create(:post, :enterprise => enterprise) }

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.group_posts_index = false
    no_access.policy_group.manage_posts = false
    no_access.policy_group.save!
  }

  permissions :view_latest_news? do

    it 'allows access to super admins' do
      user.policy_group.manage_all = true

      expect(subject).to permit(user, [group, nil])
    end

    it 'allows access when visibility is public and user has index permissions' do
      group.latest_news_visibility = 'public'

      expect(subject).to permit(user, [group, nil])
    end

    it 'denies access when visibility is public and user doesnt have index permissions' do
      group.latest_news_visibility = 'public'

      expect(subject).to_not permit(no_access, [group, nil])
    end

    it 'allows access when visibility is group and user has index permissions' do
      group.latest_news_visibility = 'group'

      expect(subject).to permit(user, [group, nil])
    end

    it 'denies access when visibility is group and user doesnt have index permissions' do
      group.latest_news_visibility = 'group'

      expect(subject).to_not permit(no_access, [group, nil])
    end

    it 'allows access when visiblity is leaders_only and user has manage permissions' do
      group.latest_news_visibility = 'leaders_only'
      user.policy_group.manage_posts = true

      expect(subject).to permit(user, [group, nil])
    end

    it 'allows access when visiblity is leaders_only and user has index permissions' do
      group.latest_news_visibility = 'leaders_only'
      user.policy_group.manage_posts = false
      user.policy_group.group_posts_index = true

      expect(subject).to permit(user, [group, nil])
    end

    it 'denies access when visiblity is leaders_only and user has no permissions' do
      group.latest_news_visibility = 'leaders_only'

      expect(subject).to_not permit(no_access, [group, nil])
    end

    it 'denies access when visiblity is unrecognized' do
      group.latest_news_visibility = nil

      expect(subject).to_not permit(no_access, [group, nil])
    end
  end
end
