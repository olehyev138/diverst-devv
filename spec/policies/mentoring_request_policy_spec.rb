require 'rails_helper'

RSpec.describe MentoringRequestPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:annual_budget) { create(:annual_budget, group: group) }
  let(:budget) { create(:budget, annual_budget: annual_budget) }
  let(:no_access) { create(:user) }
  let!(:user) { no_access }
  let(:mentoring) { create(:mentoring, mentor_id: user.id, mentee_id: user.id) }
  let(:mentoring_request) { create(:mentoring_request, sender_id: user.id, receiver_id: user.id) }

  subject { MentoringPolicy.new(user.reload, mentoring) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.mentorship_manage = false
    no_access.policy_group.save!
  }


  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when user is the sender' do
        it 'returns true for #show?' do
          expect(subject.show?).to eq true
        end
      end

      context 'when user is the receiver' do
        it 'returns true for #show?' do
          expect(subject.show?).to eq true
        end
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      it { is_expected.to permit_actions([:show, :edit]) }
    end
  end
end
