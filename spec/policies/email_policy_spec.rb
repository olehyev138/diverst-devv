require 'rails_helper'

RSpec.describe EmailPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, :no_permissions, enterprise: enterprise) }
  let!(:user) { no_access }

  subject { EmailPolicy.new(user.reload, enterprise, Email) }

  describe 'for users with access' do
    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }
      it { is_expected.to permit_actions([:update, :index, :show]) }
      it { is_expected.to forbid_actions([:create, :destroy]) }
    end

    context 'when branding manage is true' do
      before { user.policy_group.update branding_manage: true }
      it { is_expected.to permit_actions([:update, :index, :show]) }
      it { is_expected.to forbid_actions([:create, :destroy]) }
    end
  end

  describe 'for users without access' do
    context 'when everything is false' do
      it { is_expected.to forbid_actions([:create, :destroy, :update, :index, :show]) }
    end
  end
end
