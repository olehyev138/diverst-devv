require 'rails_helper'

RSpec.describe CampaignContributionsDownloadJob, type: :job do
  include ActiveJob::TestHelper

    describe '#perform' do
      it 'creates a downloadable csv file' do
        enterprise = create(:enterprise)
          user = create(:user, enterprise: enterprise)
          campaign = create(:campaign, enterprise: enterprise)

          expect { subject.perform(user.id, campaign.id, c_t(:erg)) }
            .to change(CsvFile, :count).by(1)
      end
    end
end
