require 'rails_helper'

RSpec.describe GroupsHelper do
  let(:user) { create(:user) }
  let(:group) { create(:group, enterprise_id: user.enterprise_id) }

  before do
    allow(helper).to receive(:current_user).and_return(user)
  end

  describe '#group_performance_label' do
    it 'returns the correct label' do
      expect(helper.group_performance_label(group)).to eq(link_to group.name, group)
    end

    it 'returns label when enable_rewards is set to true' do
      group.enterprise.update(enable_rewards: true)
      expect(helper.group_performance_label(group)).to include("#{group.total_weekly_points}")
    end
  end

  describe '#show_members_link' do
    it 'returns true if GroupMemberPolicy for view_members is true' do
      expect(helper.show_members_link?(group)).to eq true
    end

    it 'returns true if GroupMemberPolicy for update is true and pending_users is enabled' do
      group.update(pending_users: 'enabled')
      expect(helper.show_members_link?(group)).to eq true
    end

    it 'returns false' do
      user.policy_group = create(:policy_group, :no_permissions)
      expect(helper.show_members_link?(group)).to eq false
    end
  end

  describe '#show_manage_link?' do
    context 'for GroupLeaderPolicy' do
      it 'when .index? is true' do
        expect(helper.show_manage_link?(group)).to eq true
      end
    end

    context 'for GroupPolicy' do
      # .insights, .layouts?, .manage?, .settings? more or less are similar so it makes sense to have one example
      # each method can have its on example when their definitions diverge significantly
      it 'returns true when .insights?, .layouts?, .manage?, .settings? is true' do
        expect(helper.show_manage_link?(group)).to eq true
      end
    end

    context 'no specified policy' do
      it 'returns false' do
        user.policy_group = create(:policy_group, :no_permissions)
        expect(helper.show_manage_link?(group)).to eq false
      end
    end
  end

  describe '#show_plan_link' do
    context 'for GroupBudgetsPolicy' do
      it 'returns true when .index?, .update? is true' do
        expect(helper.show_plan_link?(group)).to eq true
      end
    end

    context 'for GroupEventsPolicy' do
      it 'returns true when .update? is true' do
        expect(helper.show_plan_link?(group)).to eq true
      end
    end

    context 'for GroupPolicy' do
      it 'returns true when .manage? is true' do
        expect(helper.show_plan_link?(group)).to eq true
      end
    end

    context 'no specified policy' do
      it 'returns false' do
        user.policy_group = create(:policy_group, :no_permissions)
        expect(helper.show_manage_link?(group)).to eq false
      end
    end
  end
end
