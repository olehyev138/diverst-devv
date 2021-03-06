require 'rails_helper'

RSpec.describe GenericGraphsTopNewsByViewsDownloadJob, type: :job do
  include ActiveJob::TestHelper

  let!(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }

  describe '#perform' do
    context 'demo' do
      it 'creates a downloadable csv file' do
        expect { subject.perform(user.id, enterprise.id, true, nil, nil) }
          .to change(CsvFile, :count).by(1)
      end
    end

    context 'non demo' do
      it 'creates a downloadable csv file' do
        expect { subject.perform(user.id, enterprise.id, false, nil, nil) }
          .to change(CsvFile, :count).by(1)
      end
    end
  end
end
