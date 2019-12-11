require 'rails_helper'

RSpec.describe GroupBudgetsDownloadJob, type: :job do
  describe '#perform' do
    it 'creates a downloadable csv file' do
      enterprise = create(:enterprise)
      user = create(:user, enterprise: enterprise)
      group = create(:group, enterprise: enterprise)

      expect { subject.perform(user.id, group.id) }
        .to change(CsvFile, :count).by(1)
    end
  end
end
