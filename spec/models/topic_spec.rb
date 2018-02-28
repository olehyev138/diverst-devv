require 'rails_helper'

RSpec.describe Topic, type: :model do 
  let(:topic) { build(:topic) }

  it { expect(topic).to belong_to(:enterprise) }
  # it { expect(topic).to belong_to(:admin) }
  it { expect(topic).to have_many(:feedbacks).class_name('TopicFeedback') }
end