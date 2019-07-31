require 'rails_helper'

RSpec.describe MentorshipInterest, type: :model do
  describe 'validations' do
    let(:mentorship_interest) { build(:mentorship_interest) }

    it { expect(mentorship_interest).to validate_presence_of(:user) }
    it { expect(mentorship_interest).to validate_presence_of(:mentoring_interest) }

    it { expect(mentorship_interest).to belong_to(:user) }
    it { expect(mentorship_interest).to belong_to(:mentoring_interest) }
  end

  describe '#as_indexed_json' do
    let(:enterprise) { create(:enterprise) }
    let(:user) { create(:user, enterprise: enterprise) }
    let(:mentoring_interest) { create(:mentoring_interest, enterprise_id: enterprise.id) }
    let!(:mentorship_interest) { create(:mentorship_interest, user_id: user.id, mentoring_interest_id: mentoring_interest.id) }

    it 'returns json' do
      hash = { 'id' => mentorship_interest.id,
               'user_id' => mentorship_interest.user_id,
               'mentoring_interest_id' => mentorship_interest.mentoring_interest.id,
               'created_at' => mentorship_interest.created_at,
               'updated_at' => mentorship_interest.updated_at,
               'user' => { 'enterprise_id' => mentorship_interest.mentoring_interest.enterprise_id },
               'mentoring_interest' => { 'name' => mentorship_interest.mentoring_interest.name } }

      expect(mentorship_interest.as_indexed_json).to eq(hash)
    end
  end
end
