require 'rails_helper'

RSpec.describe MentoringSessionTopic, type: :model do
  describe 'validations' do
    let(:mentoring_session_topic) { build_stubbed(:mentoring_session_topic) }

    it { expect(mentoring_session_topic).to belong_to(:mentoring_session) }
    it { expect(mentoring_session_topic).to belong_to(:mentoring_interest) }

    it { expect(mentoring_session_topic).to validate_presence_of(:mentoring_session) }
    it { expect(mentoring_session_topic).to validate_presence_of(:mentoring_interest) }
  end
end
