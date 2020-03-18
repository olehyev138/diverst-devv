require 'rails_helper'

RSpec.describe UsersPointsDownloadJob, type: :job do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise, points: 11) }

  describe '#perform' do
    context 'for all users' do
      it 'creates a downloadable csv file for all users in desc order of points' do
        expect { subject.perform(user.id) }
          .to change(CsvFile, :count).by(1)
      end

      it 'file name' do
        subject.perform(user.id)
        expect(CsvFile.last.download_file_name).to eq 'users_points_report'
      end
    end
  end
end
