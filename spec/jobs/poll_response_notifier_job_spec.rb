require 'rails_helper'

RSpec.describe PollResponseNotifierJob, type: :job do
  let!(:user) { create(:user) }
  let!(:poll) { create(:poll) }
  let!(:response) { create(:poll_response, poll_id: poll.id, user_id: user.id) }

  it 'calls ResponseNotifier after creating a poll response' do
    response_id = response.id
    notifier = double('Notifiers::ResponseNotifier')
    expect(Notifiers::ResponseNotifier).to receive(:new) { notifier }.with(response_id).exactly(1).times
    expect(notifier).to receive('notify!').exactly(1).times

    PollResponseNotifierJob.perform_now(response_id)
  end
end
