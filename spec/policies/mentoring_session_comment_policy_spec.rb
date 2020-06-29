require 'rails_helper'

RSpec.describe MentoringSessionCommentPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:annual_budget) { create(:annual_budget, group: group) }
  let(:budget) { create(:budget, annual_budget: annual_budget) }
  let(:no_access) { create(:user) }
  let!(:user) { no_access }
  let(:mentoring_session_comment) { create(:mentoring_session_comment, user_id: user.id) }


  subject { MentoringSessionCommentPolicy.new(user.reload, mentoring_session_comment) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.mentorship_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when user is the creator' do
        it 'returns true for #creator?' do
          expect(subject.creator?).to eq true
        end
      end
    end
  end
end
