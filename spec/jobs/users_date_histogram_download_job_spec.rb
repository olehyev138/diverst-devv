require 'rails_helper'

RSpec.describe UsersDateHistogramDownloadJob, type: :job do
  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }

  describe '#perform' do
    it 'creates a downloadable csv file' do
      allow_any_instance_of(Enterprise).to receive(:users_date_histogram_csv).and_return('')
      expect { subject.perform(user.id, enterprise.id) }
        .to change(CsvFile.all, :count).by(1)
    end
  end
end
