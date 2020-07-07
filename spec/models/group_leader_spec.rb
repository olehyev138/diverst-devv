require 'rails_helper'

RSpec.describe GroupLeader, type: :model do
  describe 'test validations and associations' do
    let(:group_leader) { build(:group_leader) }

    it { expect(group_leader).to validate_presence_of(:position_name) }
    it { expect(group_leader).to validate_presence_of(:group) }
    it { expect(group_leader).to validate_presence_of(:user) }
    it { expect(group_leader).to validate_presence_of(:user_role) }
    it { expect(group_leader).to validate_uniqueness_of(:user_id).with_message('already exists as a group leader').scoped_to(:group_id) }
    it { expect(group_leader).to validate_length_of(:position_name).is_at_most(191) }
    it { expect(group_leader).to belong_to(:user) }
    it { expect(group_leader).to belong_to(:group) }
    it { expect(group_leader).to belong_to(:user_role) }
    it { expect(group_leader).to have_one(:policy_group_template).through(:user_role) }
  end

  describe 'test scopes' do
    let!(:group_leaders) { create_list(:group_leader, 3) }

    it 'GroupLeader::visible' do
      expect(GroupLeader.visible.count).to eq 3
    end

    it 'GroupLeader::role_ids' do
      expect(GroupLeader.role_ids.count).to eq 3
    end
  end


  describe '#user_id' do
    it 'validates user cannot be added as group leader to group twice' do
      user = create(:user)
      group = create(:group, enterprise: user.enterprise)
      group_2 = create(:group, enterprise: user.enterprise)
      create(:user_group, group: group, user: user)
      create(:user_group, group: group_2, user: user)

      # validate that the first group leader is valid
      group_leader = create(:group_leader, user: user, group: group)
      expect(group_leader.valid?).to be(true)

      # validate that the second group leader is not valid since a user cannot be
      # a group leader in 1 group twice
      group_leader_2 = build(:group_leader, user: user, group: group)
      expect(group_leader_2.valid?).to_not be(true)

      # validate that the second group leader is valid since a user can be
      # a group leader in 2 groups once
      group_leader_3 = create(:group_leader, user: user, group: group_2)
      expect(group_leader_3.valid?).to be(true)
    end

    it 'validates that user selected as group leader is a member of group' do
      user = create(:user)
      group = create(:group, enterprise: user.enterprise)
      create(:user_group, user: user, group: group, accepted_member: true)
      group_leader = build(:group_leader, user: user, group: group)

      expect(group_leader.valid?).to be(true)
    end
  end
end
