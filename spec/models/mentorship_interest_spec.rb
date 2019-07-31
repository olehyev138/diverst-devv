require 'rails_helper'

RSpec.describe MentorshipInterest, type: :model do
  let(:mentorship_interest) { build(:mentorship_interest) }

  describe 'validations' do
    it { expect(mentorship_interest).to validate_presence_of(:user) }
    it { expect(mentorship_interest).to validate_presence_of(:mentoring_interest) }

    it { expect(mentorship_interest).to belong_to(:user) }
    it { expect(mentorship_interest).to belong_to(:mentoring_interest) }
  end

  describe '#as_indexed_json' do
    it 'returns json' do
      hash = { 'id' => mentorship_interest.id,
               'user_id' => mentorship_interest.user_id,
               'mentoring_interest_id' => mentorship_interest.mentoring_interest.id,
               'created_at' => nil,
               'updated_at' => nil,
               'user' => { 'enterprise_id' => mentorship_interest.user_id },
               'mentoring_interest' => { 'name' => mentorship_interest.mentoring_interest.name } }
      expect(mentorship_interest.as_indexed_json).to eq(hash)
    end
  end
end
