require 'rails_helper'

RSpec.describe PolicyGroupTemplatePolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:policy_group_template) { create(:policy_group_template, enterprise: enterprise) }

  subject { PolicyGroupTemplatePolicy.new(user, policy_group_template) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.permissions_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when permissions_manage is true' do
        before { user.policy_group.update permissions_manage: true }
        it { is_expected.to permit_actions([:index, :new, :create, :update, :destroy]) }
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }
      it { is_expected.to permit_actions([:index, :new, :create, :update, :destroy]) }
    end
  end

  describe 'for users with no access' do
    it { is_expected.to forbid_actions([:index, :new, :create, :update, :destroy]) }
  end
end
