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

  describe 'set_admin_permissions' do
    let!(:user) { create(:user) }
    let!(:group_leader) { create(:group_leader, user: user) }

    it 'returns budgets permission' do
      expect(group_leader.groups_budgets_index).to eq group_leader.user.user_role.policy_group_template.groups_budgets_index
      expect(group_leader.groups_budgets_request).to eq group_leader.user.user_role.policy_group_template.groups_budgets_request
      expect(group_leader.budget_approval).to eq group_leader.user.user_role.policy_group_template.budget_approval
      expect(group_leader.groups_budgets_manage).to eq group_leader.user.user_role.policy_group_template.groups_budgets_manage
    end

    it 'returns events permission' do
      expect(group_leader.initiatives_index).to eq group_leader.user.user_role.policy_group_template.initiatives_index
      expect(group_leader.initiatives_manage).to eq group_leader.user.user_role.policy_group_template.initiatives_manage
      expect(group_leader.initiatives_create).to eq group_leader.user.user_role.policy_group_template.initiatives_create
    end

    it 'returns groups manage permission' do
      expect(group_leader.groups_manage).to eq group_leader.user.user_role.policy_group_template.groups_manage
    end

    it 'returns members permission' do
      expect(group_leader.groups_members_index).to eq group_leader.user.user_role.policy_group_template.groups_members_index
      expect(group_leader.groups_members_manage).to eq group_leader.user.user_role.policy_group_template.groups_members_manage
    end

    it 'returns leaders permission' do
      expect(group_leader.group_leader_index).to eq group_leader.user.user_role.policy_group_template.group_leader_index
      expect(group_leader.group_leader_manage).to eq group_leader.user.user_role.policy_group_template.group_leader_manage
    end

    it 'returns insights permission' do
      expect(group_leader.groups_insights_manage).to eq group_leader.user.user_role.policy_group_template.groups_insights_manage
    end

    it 'returns layouts permission' do
      expect(group_leader.groups_layouts_manage).to eq group_leader.user.user_role.policy_group_template.groups_layouts_manage
    end

    it 'returns settings permission' do
      expect(group_leader.group_settings_manage).to eq group_leader.user.user_role.policy_group_template.group_settings_manage
    end

    it 'returns news permission' do
      expect(group_leader.news_links_index).to eq group_leader.user.user_role.policy_group_template.news_links_index
      expect(group_leader.news_links_create).to eq group_leader.user.user_role.policy_group_template.news_links_create
      expect(group_leader.news_links_manage).to eq group_leader.user.user_role.policy_group_template.news_links_manage
    end

    it 'returns messages permission' do
      expect(group_leader.group_messages_manage).to eq group_leader.user.user_role.policy_group_template.group_messages_manage
      expect(group_leader.group_messages_index).to eq group_leader.user.user_role.policy_group_template.group_messages_index
      expect(group_leader.group_messages_create).to eq group_leader.user.user_role.policy_group_template.group_messages_create
    end

    it 'returns social links permission' do
      expect(group_leader.social_links_manage).to eq group_leader.user.user_role.policy_group_template.social_links_manage
      expect(group_leader.social_links_index).to eq group_leader.user.user_role.policy_group_template.social_links_index
      expect(group_leader.social_links_create).to eq group_leader.user.user_role.policy_group_template.social_links_create
    end

    it 'returns resources permission' do
      expect(group_leader.group_resources_manage).to eq group_leader.user.user_role.policy_group_template.group_resources_manage
      expect(group_leader.group_resources_index).to eq group_leader.user.user_role.policy_group_template.group_resources_index
      expect(group_leader.group_resources_create).to eq group_leader.user.user_role.policy_group_template.group_resources_create
    end

    it 'returns posts permission' do
      expect(group_leader.group_posts_index).to eq group_leader.user.user_role.policy_group_template.group_posts_index
      expect(group_leader.manage_posts).to eq group_leader.user.user_role.policy_group_template.manage_posts
    end
  end
end
