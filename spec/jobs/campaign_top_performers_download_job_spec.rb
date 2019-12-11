require 'rails_helper'

RSpec.describe CampaignTopPerformersDownloadJob, type: :job do
  describe '#perform' do
    it 'creates a downloadable csv file' do
      enterprise = create(:enterprise)
      user = create(:user, enterprise: enterprise)
      campaign = create(:campaign, enterprise: enterprise)

      expect { subject.perform(user.id, campaign.id) }
        .to change(CsvFile, :count).by(1)
    end
  end
end
