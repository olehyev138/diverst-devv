require 'rails_helper'

RSpec.describe PollsSegment, type: :model do
  let!(:polls_segment) { build_stubbed(:polls_segment) }

  it { expect(polls_segment).to belong_to(:poll) }
  it { expect(polls_segment).to belong_to(:segment) }
end
