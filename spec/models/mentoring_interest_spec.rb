require 'rails_helper'

RSpec.describe MentoringInterest, type: :model do
  describe 'test associations and validations' do
    let(:mentoring_interest) { build(:mentoring_interest) }

    it { expect(mentoring_interest).to have_many(:mentorship_interests) }
    it { expect(mentoring_interest).to have_many(:users).through(:mentorship_interests) }

    it { expect(mentoring_interest).to validate_presence_of(:name) }
    it { expect(mentoring_interest).to validate_length_of(:name).is_at_most(191) }
  end
end
