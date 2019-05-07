require 'rails_helper'

RSpec.describe GenericGraphsEventsCreatedDownloadJob, type: :job do
  include ActiveJob::TestHelper

    let!(:enterprise) { create(:enterprise) }
    let!(:user) { create(:user, enterprise: enterprise) }

    describe '#perform' do
      context 'demo' do
        it 'creates a downloadable csv file' do
          expect { subject.perform(user.id, enterprise.id, c_t(:erg), true, nil, nil) }
            .to change(CsvFile, :count).by(1)
        end
      end

      context 'non demo' do
        it 'creates a downloadable csv file' do
          expect { subject.perform(user.id, enterprise.id, c_t(:erg), false, nil, nil) }
            .to change(CsvFile, :count).by(1)
        end
      end
    end
end
