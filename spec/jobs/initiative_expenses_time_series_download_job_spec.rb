require 'rails_helper'

RSpec.describe InitiativeExpensesTimeSeriesDownloadJob, type: :job do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user) }
  let(:group) { create(:group, enterprise: user.enterprise) }
  let(:initiative) { initiative_of_group(group) }
  let(:initiative_expense) { create(:initiative_expense, initiative: initiative) }

  describe '#perform' do
    it 'creates a downloadable csv file' do
      expect { subject.perform(user.id, initiative.id) }
        .to change(CsvFile, :count).by(1)
    end
  end
end
