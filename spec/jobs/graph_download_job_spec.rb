require 'rails_helper'

RSpec.describe GraphDownloadJob, type: :job do
    include ActiveJob::TestHelper

    let(:enterprise) { create(:enterprise) }
    let(:user) { create(:user, enterprise: enterprise) }
    let(:metrics_dashboard) { create(:metrics_dashboard, enterprise_id: enterprise.id) }
    let(:poll) { create(:poll, enterprise_id: enterprise.id) }
    let(:field1) { create(:field, type: "NumericField", poll: poll) }
    let(:field2) { create(:field, type: "NumericField", poll: poll) }
    let(:field3) { create(:field, type: "CheckboxField", poll: poll) }
    let(:metrics_graph) { create(:graph, metrics_dashboard: metrics_dashboard, field: field1) }
    let(:poll_graph) { create(:graph, poll: poll, field: field2) }

    describe "#perform" do
        before { User.__elasticsearch__.create_index!(index: User.es_index_name(enterprise: enterprise)) }
        after { User.__elasticsearch__.delete_index!(index: User.es_index_name(enterprise: enterprise)) }

        context "poll graph" do
          it "creates a downloadable csv file" do
              expect{ subject.perform(user.id, poll_graph.id) }
                .to change(CsvFile, :count).by(1)
          end
        end

        context "metrics graph" do
          it "creates a downloadable csv file" do
              expect{ subject.perform(user.id, metrics_graph.id) }
                .to change(CsvFile, :count).by(1)
          end
        end
    end
end
