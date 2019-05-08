require 'rails_helper'

RSpec.describe GroupsCloseBudgetsDownloadJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    it 'creates a downloadable csv file' do
      enterprise = create(:enterprise)
      user = create(:user, enterprise: enterprise)

      expect { subject.perform(user.id, enterprise.id) }
        .to change(CsvFile, :count).by(1)
    end
  end
end
