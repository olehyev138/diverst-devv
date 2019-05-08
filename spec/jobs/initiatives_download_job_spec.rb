require 'rails_helper'

RSpec.describe InitiativesDownloadJob, type: :job do
  include ActiveJob::TestHelper

  let(:enterprise) { create :enterprise }
  let(:user) { create :user, enterprise: enterprise }
  let!(:group) { create :group, enterprise: enterprise }
  let(:outcome) { create :outcome, group_id: group.id }
  let(:pillar) { create :pillar, outcome_id: outcome.id }
  let(:initiative) { create :initiative, pillar: pillar, owner_group: group }

  describe '#perform' do
    it 'creates a downloadable csv file' do
      expect { subject.perform(user.id, group.id, outcome.pillars.collect { |p| p.initiatives.map { |i| i.id } }.flatten) }
        .to change(CsvFile, :count).by(1)
    end
  end
end
