require 'rails_helper'

RSpec.describe GroupMemberPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:group){ create(:group, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:member){ create(:member, :enterprise => enterprise)}

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_groups.manage_all = false
    no_access.policy_group.groups_members_index = false
    no_access.policy_group.groups_members_manage = false
    no_access.policy_group.save!
  }

end
