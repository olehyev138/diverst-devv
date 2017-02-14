require 'rails_helper'

RSpec.describe Reports::GraphStats do
  let(:graph_stats){ Reports::GraphStats.new(graph) }
  let!(:enterprise){ create(:enterprise) }
  let!(:user){ create(:user, enterprise: enterprise) }
  let!(:poll){ create(:poll, enterprise: enterprise) }
  let!(:field){ SelectField.create!(attributes_for(:select_field, container: poll)) }
  let!(:aggregation){ SelectField.create!(attributes_for(:select_field, container: poll)) }
  let!(:poll_response){ create(:poll_response, user: user, poll: poll, data: { field.id.to_s => "Yes" }.to_json) }

  context "when there is an aggregate field" do
    before(:each){ User.__elasticsearch__.refresh_index! }
    let!(:graph){ create(:poll_graph, field: field, collection: poll) }

    xit "return the header of spreadsheet" do
    end

    xit "return the body of spreadsheet" do
    end
  end

  context "when there is not an aggregate field" do
    let!(:graph){ create(:poll_graph, field: field, collection: poll, aggregation: aggregation) }

    xit "return the header of spreadsheet" do
    end

    xit "return the body of spreadsheet" do

    end
  end
end
