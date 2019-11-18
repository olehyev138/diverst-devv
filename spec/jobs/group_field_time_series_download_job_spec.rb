require 'rails_helper'

RSpec.describe GroupFieldTimeSeriesDownloadJob, type: :job do
  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }
  let!(:group) { create(:group, enterprise: enterprise) }
  let!(:field) { create(:field, type: 'NumericField', group: group, field_type: 'regular') }

  describe '#perform' do
    it 'creates a downloadable csv file' do
      expect { subject.perform(user.id, group.id, field.id) }
        .to change(CsvFile, :count).by(1)
    end
  end
end
