require 'rails_helper'

RSpec.describe GraphDownloadJob, type: :job do
  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }
  let(:metrics_dashboard) { create(:metrics_dashboard, enterprise_id: enterprise.id) }
  let(:poll) { create(:poll, enterprise_id: enterprise.id) }
  let(:field1) { create(:field, type: 'NumericField', field_definer: poll) }
  let(:field2) { create(:field, type: 'NumericField', field_definer: poll) }
  let(:field3) { create(:field, type: 'CheckboxField', field_definer: poll) }
  let(:metrics_graph) { create(:graph_with_metrics_dashboard, metrics_dashboard: metrics_dashboard, field: field1) }
  let(:poll_graph) { create(:graph_with_metrics_dashboard, poll: poll, field: field2) }

  before {
    allow_any_instance_of(Graph).to receive(:graph_csv).and_return('')
  }

  describe '#perform' do
    context 'poll graph' do
      it 'creates a downloadable csv file' do
        expect { subject.perform(user.id, poll_graph.id, '', []) }
          .to change(CsvFile, :count).by(1)
      end
    end

    context 'metrics graph' do
      it 'creates a downloadable csv file' do
        expect { subject.perform(user.id, metrics_graph.id, '', []) }
          .to change(CsvFile, :count).by(1)
      end
    end
  end
end
