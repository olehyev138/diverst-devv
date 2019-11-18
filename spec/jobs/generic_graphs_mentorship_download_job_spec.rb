require 'rails_helper'

RSpec.describe GenericGraphsMentorshipDownloadJob, type: :job do
  describe '#perform' do
    it 'creates a downloadable csv file' do
      enterprise = create(:enterprise)
      user = create(:user, enterprise: enterprise)

      expect { subject.perform(user.id, enterprise.id, enterprise.c_t(:erg)) }
        .to change(CsvFile, :count).by(1)
    end
  end
end
