require 'rails_helper'

RSpec.describe InitiativeFieldTimeSeriesDownloadJob, type: :job do
  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:initiative) { initiative_of_group(group) }
  let(:field) { create(:field, field_definer: initiative, elasticsearch_only: false) }
  let(:initiative_field) { create :initiative_field, initiative: initiative, field: field }

  describe '#perform' do
    it 'creates a downloadable csv file' do
      expect { subject.perform(user.id, initiative.id, field.id) }
        .to change(CsvFile, :count).by(1)
    end
  end
end
