require 'rails_helper'

RSpec.describe AnnualBudgetPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:annual_budget) { create(:annual_budget, group: group) }
  let(:budget) { create(:budget, annual_budget: annual_budget) }
  let(:no_access) { create(:user) }
  let!(:user) { no_access }

  subject { described_class.new(user.reload, [group, annual_budget]) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.groups_manage = false
    no_access.policy_group.groups_members_index = false
    no_access.policy_group.groups_members_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'AnnualBudget Index' do
      context 'when manage_all is false' do

      end
      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        context 'when groups_members_manage, groups_manage and groups_members_index are false' do
          before { user.policy_group.update groups_members_manage: false, groups_manage: false, groups_members_index: false }
          it { is_expected.to permit_actions([:create, :destroy]) }

          it 'returns true for #view_members?' do
            expect(subject.index?).to eq true
          end
        end
      end

    # manage all
    #
  end
  end
  end