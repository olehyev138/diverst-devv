require 'rails_helper'

RSpec.describe EventAttendeeDownloadJob, type: :job do
  include ActiveJob::TestHelper

  let(:enterprise) { create :enterprise }
  let(:user) { create :user, enterprise: enterprise }
  let!(:group) { create :group, enterprise: enterprise }
  let(:outcome) { create :outcome, group_id: group.id }
  let(:pillar) { create :pillar, outcome_id: outcome.id }
  let(:initiative) { create :initiative, pillar: pillar, owner_group: group }
  before { initiative.attendees << user }

  describe '#perform' do
    it 'creates a download csv file' do
      expect { subject.perform(user, initiative).to change(CsvFile, :count).by(1) }
    end
  end
end
