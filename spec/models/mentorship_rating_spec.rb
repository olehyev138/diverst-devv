require 'rails_helper'

RSpec.describe MentorshipRating, type: :model do
  describe 'test associations and validations' do
    let(:mentorship_rating) { build_stubbed(:mentorship_rating) }

    it { expect(mentorship_rating).to validate_presence_of(:user) }
    it { expect(mentorship_rating).to validate_presence_of(:mentoring_session) }
    it { expect(mentorship_rating).to validate_presence_of(:rating) }
    it { expect(mentorship_rating).to validate_length_of(:comments).is_at_most(65535) }

    it { expect(mentorship_rating).to belong_to(:user) }
    it { expect(mentorship_rating).to belong_to(:mentoring_session) }
  end
end
