require 'rails_helper'

RSpec.describe PolicyGroupTemplatePolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:policy_group_template) { create(:user_role, role_type: 'user', enterprise: enterprise).policy_group_template }

  subject { PolicyGroupTemplatePolicy.new(user.reload, policy_group_template) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.permissions_manage = false
    no_access.policy_group.users_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when permissions_manage is true' do
        before { user.policy_group.update permissions_manage: true }
        it { is_expected.to permit_actions([:index, :update]) }
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }
      it { is_expected.to permit_actions([:index, :update]) }
    end
  end

  describe 'for users with no access' do
    it { is_expected.to forbid_actions([:index, :new, :create, :update, :destroy]) }
  end
end
