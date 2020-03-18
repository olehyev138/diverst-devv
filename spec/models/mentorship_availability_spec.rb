require 'rails_helper'

RSpec.describe MentorshipAvailability, type: :model do
  describe 'validations' do
    let(:mentorship_availability) { build_stubbed(:mentorship_availability) }

    it { expect(mentorship_availability).to validate_presence_of(:user) }
    it { expect(mentorship_availability).to validate_presence_of(:day) }
    it { expect(mentorship_availability).to validate_presence_of(:start) }
    it { expect(mentorship_availability).to validate_presence_of(:end) }

    it { expect(mentorship_availability).to belong_to(:user) }
  end
end
