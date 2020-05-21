require 'rails_helper'

RSpec.describe MentoringSessionComment, type: :model do
  describe 'validations' do
    let(:mentoring_session_comment) { build_stubbed(:mentoring_session_comment) }

    it { expect(mentoring_session_comment).to validate_presence_of(:user) }
    it { expect(mentoring_session_comment).to validate_presence_of(:mentoring_session) }
    it { expect(mentoring_session_comment).to validate_presence_of(:content) }
    it { expect(mentoring_session_comment).to validate_length_of(:content).is_at_most(65535) }

    it { expect(mentoring_session_comment).to belong_to(:user) }
    it { expect(mentoring_session_comment).to belong_to(:mentoring_session) }
  end
end
