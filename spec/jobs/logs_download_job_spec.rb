require 'rails_helper'

RSpec.describe LogsDownloadJob, type: :job do
  include ActiveJob::TestHelper

  let!(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }

  describe '#perform' do
    it 'creates a downloadable csv file' do
      expect { subject.perform(user.id, enterprise.id) }
        .to change(CsvFile, :count).by(1)
    end
  end
end
