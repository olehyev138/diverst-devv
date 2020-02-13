require 'rails_helper'

RSpec.describe UserRolePolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:user_role) { create(:user_role) }

  subject { UserRolePolicy.new(user, user_role) }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.users_manage = false
    no_access.policy_group.users_index = false
    no_access.policy_group.save!
  }

  describe 'for user with access' do
    context 'when manage_all is false' do
      context 'when users_index and users_manage are true' do
        before { user.policy_group.update users_index: true, users_manage: true }
        it { is_expected.to permit_actions([:index, :new, :create, :update, :destroy]) }
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      context 'when users_index and users_manage are false' do
        it { is_expected.to permit_actions([:index, :new, :create, :update, :destroy]) }
      end
    end
  end

  describe 'for user with no access' do
    let!(:user) { no_access }

    context 'when users_index and users_manage are false' do
      it { is_expected.to forbid_actions([:index, :new, :create, :update, :destroy]) }
    end
  end
end
