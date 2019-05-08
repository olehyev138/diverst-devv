require 'rails_helper'

RSpec.describe MentorshipType, type: :model do
  describe 'validations' do
    let(:mentorship_type) { build_stubbed(:mentorship_type) }

    it { expect(mentorship_type).to validate_presence_of(:user) }
    it { expect(mentorship_type).to validate_presence_of(:mentoring_type) }

    it { expect(mentorship_type).to belong_to(:user) }
    it { expect(mentorship_type).to belong_to(:mentoring_type) }
  end
end
