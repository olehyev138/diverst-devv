require 'rails_helper'

RSpec.describe GenericGraphsGroupGrowthDownloadJob, type: :job do
  describe '#perform' do
    it 'creates a downloadable csv file' do
      enterprise = create(:enterprise)
      user = create(:user, enterprise: enterprise)

      expect {
        subject
          .perform(user.id, enterprise.id, 1.year.ago.to_s, 1.year.from_now.to_s)
      }.to change(CsvFile, :count).by(1)
    end
  end
end
