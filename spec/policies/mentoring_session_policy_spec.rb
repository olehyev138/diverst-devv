require 'rails_helper'

RSpec.describe MentoringSessionPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:annual_budget) { create(:annual_budget, group: group) }
  let(:budget) { create(:budget, annual_budget: annual_budget) }
  let(:no_access) { create(:user) }
  let!(:user) { no_access }
  let(:mentoring_session) { create(:mentoring_session, creator_id: user.id) }

  subject { MentoringSessionPolicy.new(user.reload, mentoring_session) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.mentorship_manage = false
    no_access.policy_group.save!
  }


  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'creator?' do
        context 'when user is the creator' do
          it 'returns true for #creator?' do
            expect(subject.creator?).to eq true
          end
        end
      end

      context 'invited_user?' do
        # todo
      end

      context 'accepted_user?' do
        # todo
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      it { is_expected.to permit_actions([:show, :update]) }
    end
  end
end
