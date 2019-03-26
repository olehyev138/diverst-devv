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
  let(:metrics_graph) { create(:graph_with_metrics_dashboard, metrics_dashboard: metrics_dashboard, field: field1) }
  let(:poll_graph) { create(:graph_with_metrics_dashboard, poll: poll, field: field2) }

  describe "#perform" do
    context "poll graph" do
      before {
        g = 'UserGroup'
        g = g.constantize
        g.__elasticsearch__.delete_index! if g.__elasticsearch__.index_exists?;
        g.__elasticsearch__.create_index!

        g = 'UsersSegment'
        g = g.constantize
        g.__elasticsearch__.delete_index! if g.__elasticsearch__.index_exists?;
        g.__elasticsearch__.create_index!
      }

      it "creates a downloadable csv file" do
        expect{ subject.perform(user.id, poll_graph.id, '', []) }
          .to change(CsvFile, :count).by(1)
      end
    end

    context "metrics graph" do
      before {
        g = 'UserGroup'
        g = g.constantize
        g.__elasticsearch__.delete_index! if g.__elasticsearch__.index_exists?;
        g.__elasticsearch__.create_index!

        g = 'UsersSegment'
        g = g.constantize
        g.__elasticsearch__.delete_index! if g.__elasticsearch__.index_exists?;
        g.__elasticsearch__.create_index!
      }

      it "creates a downloadable csv file" do
        expect{ subject.perform(user.id, metrics_graph.id, '', []) }
          .to change(CsvFile, :count).by(1)
      end
    end
  end
end
