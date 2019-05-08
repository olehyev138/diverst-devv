require 'rails_helper'

RSpec.describe PollDecorator do
  let(:poll) { create :poll }

  describe '#status' do
    it 'returns Published' do
      poll.status = 0
      decorated_poll = poll.decorate
      expect(decorated_poll.status).to eq('Published')
    end

    it 'returns Draft' do
      poll.status = 1
      decorated_poll = poll.decorate
      expect(decorated_poll.status).to eq('Draft')
    end
  end
end
