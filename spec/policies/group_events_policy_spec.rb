require 'rails_helper'

RSpec.describe GroupEventsPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:group){ create(:group, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:event){ create(:event, :enterprise => enterprise)}

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.initiatives_index = false
    no_access.policy_group.initiatives_create = false
    no_access.policy_group.initiatives_manage = false
    no_access.policy_group.save!
  }

  permissions :view_upcoming_events?, :view_upcoming_and_ongoing_events? do

    it 'allows access to super admins' do
      user.policy_group.manage_all = true

      expect(subject).to permit(user, [group, nil])
    end

    it 'allows access when visibility is public and user has index permissions' do
      group.upcoming_events_visibility = 'public'

      expect(subject).to permit(user, [group, nil])
    end

    it 'denies access when visibility is public and user doesnt have index permissions' do
      group.upcoming_events_visibility = 'public'

      expect(subject).to_not permit(no_access, [group, nil])
    end

    it 'allows access when visibility is group and user has index permissions' do
      group.upcoming_events_visibility = 'group'

      expect(subject).to permit(user, [group, nil])
    end

    it 'denies access when visibility is group and user doesnt have index permissions' do
      group.upcoming_events_visibility = 'group'

      expect(subject).to_not permit(no_access, [group, nil])
    end

    it 'allows access when visiblity is leaders_only and user has manage permissions' do
      group.upcoming_events_visibility = 'leaders_only'

      expect(subject).to permit(user, [group, nil])
    end

    it 'allows access when visiblity is leaders_only and user has create permissions' do
      group.upcoming_events_visibility = 'leaders_only'
      user.policy_group.initiatives_manage = false

      expect(subject).to permit(user, [group, nil])
    end

    it 'allows access when visiblity is leaders_only and user has index permissions' do
      group.upcoming_events_visibility = 'leaders_only'
      user.policy_group.initiatives_manage = false
      user.policy_group.initiatives_create = false

      expect(subject).to permit(user, [group, nil])
    end

    it 'denies access when visiblity is leaders_only and user has no permissions' do
      group.upcoming_events_visibility = 'leaders_only'

      expect(subject).to_not permit(no_access, [group, nil])
    end

    it 'denies access when visiblity is unrecognized' do
      group.upcoming_events_visibility = nil

      expect(subject).to_not permit(no_access, [group, nil])
    end
  end
end
