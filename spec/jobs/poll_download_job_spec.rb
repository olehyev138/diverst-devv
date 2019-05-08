require 'rails_helper'

RSpec.describe PollDownloadJob, type: :job do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }
  let!(:poll) { create(:poll, status: 0, enterprise: user.enterprise, groups: []) }

  describe '#perform' do
    it 'creates a downloadable csv file' do
      expect { subject.perform(user.id, poll.id) }
        .to change(CsvFile, :count).by(1)
    end
  end
end
