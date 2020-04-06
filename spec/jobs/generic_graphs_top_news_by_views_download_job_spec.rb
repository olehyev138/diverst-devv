require 'rails_helper'

RSpec.describe GenericGraphsTopNewsByViewsDownloadJob, type: :job do
  let!(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }

  describe '#perform' do
    context 'demo' do
      # TODO Fix MySQL errors on CircleCI with these tests
      it 'creates a downloadable csv file' do
        pending
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
