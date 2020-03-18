require 'rails_helper'

RSpec.describe EnterpriseResourcePolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }

  subject { EnterpriseResourcePolicy.new(user.reload, nil) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.enterprise_resources_index = false
    no_access.policy_group.enterprise_resources_create = false
    no_access.policy_group.enterprise_resources_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when enterprise_resources_index is true' do
        before { user.policy_group.update enterprise_resources_index: true }
        it { is_expected.to permit_action(:index) }
      end

      context 'when enterprise_resources_create is true' do
        before { user.policy_group.update enterprise_resources_create: true }
        it { is_expected.to permit_actions([:index, :create]) }
      end

      context 'when enterprise_resources_manage is true' do
        before { user.policy_group.update enterprise_resources_manage: true }
        it { is_expected.to permit_actions([:index, :create, :edit, :update, :destroy]) }
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }
      it { is_expected.to permit_actions([:index, :create, :edit, :update, :destroy]) }
    end
  end

  describe 'for users with no access' do
    it { is_expected.to forbid_actions([:index, :create, :edit, :update, :destroy]) }
  end
end
