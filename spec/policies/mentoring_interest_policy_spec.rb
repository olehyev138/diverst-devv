require 'rails_helper'

RSpec.describe MentoringInterestPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:mentoring_interest) { create(:mentoring_interest, enterprise_id: enterprise.id) }

  subject { MentoringInterestPolicy.new(user.reload, mentoring_interest) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.mentorship_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when mentorship_manage is true' do
        before { user.policy_group.update mentorship_manage: true }
        it { is_expected.to permit_actions([:index, :create, :edit, :update, :destroy]) }
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }
      it { is_expected.to permit_actions([:index, :create, :edit, :update, :destroy]) }
    end
  end

  describe 'for users with no access' do
    it { is_expected.to forbid_actions([:index, :edit, :create, :update, :destroy]) }
  end
end
