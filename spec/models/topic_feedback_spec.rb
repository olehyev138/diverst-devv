require 'rails_helper'

RSpec.describe TopicFeedback, type: :model do
  let(:topic_feedback) { build_stubbed(:topic_feedback) }

  it { expect(topic_feedback).to belong_to(:topic) }
  it { expect(topic_feedback).to belong_to(:user) }
end
