require 'rails_helper'

RSpec.describe ClearExpiredFilesJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    it 'destroys expired files' do
      enterprise = create(:enterprise)
      user = create(:user, enterprise: enterprise)
      create(:csv_file,
             user: user,
             download_file_name: 'sponsor_image',
             download_file: { io: File.open('spec/fixtures/files/sponsor_image.jpg'), filename: 'sponsor_image.jpg' },
             created_at: Time.now - 2.hours)

      expect { subject.perform }
        .to change(CsvFile, :count).by(-1)
    end
  end
end
