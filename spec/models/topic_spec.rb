require 'rails_helper'

RSpec.describe Topic, type: :model do
  let(:topic) { build_stubbed(:topic) }

  it { expect(topic).to belong_to(:enterprise) }
  # it { expect(topic).to belong_to(:user) }
  it { expect(topic).to have_many(:feedbacks).class_name('TopicFeedback').dependent(:destroy) }
  it { expect(topic).to validate_length_of(:statement).is_at_most(65535) }

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      topic = create(:topic)
      topic_feedback = create(:topic_feedback, topic: topic)

      topic.destroy

      expect { Topic.find(topic.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { TopicFeedback.find(topic_feedback.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
