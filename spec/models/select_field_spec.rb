require 'rails_helper'

RSpec.describe SelectField, elasticsearch: true, type: :model, :skip => "Need to fix - written by gabriel" do
  context "when getting data" do
    let!(:field_one) { SelectField.create(attributes_for(:select_field)) }
    let!(:field_two) { SelectField.create(attributes_for(:select_field, options_text: "Yes2\nNo2")) }

    let!(:enterprise) { create(:enterprise) }

    let!(:group) { create(:group, enterprise: enterprise) }

    let!(:segment_one) { create(:segment, enterprise: enterprise) }
    let!(:segment_two) { create(:segment, enterprise: enterprise) }

    let!(:user_one) { create(:user, enterprise: enterprise, groups: [group],
      segments: [segment_one], created_at: Date.yesterday) }
    let!(:user_two) { create(:user, enterprise: enterprise, groups: [group],
      segments: [segment_two], created_at: Date.yesterday) }
    let!(:user_three) { create(:user, enterprise: enterprise,
      segments: [segment_one, segment_two], created_at: Date.today) }
    let!(:user_four) { create(:user, enterprise: enterprise, groups: [group],
      segments: [segment_one, segment_two], created_at: Date.today) }

    before(:each) do
      enterprise.fields = [field_one, field_two]

      # Save fields on users
      user_one.info.merge(fields: [field_one, field_two], form_data: { field_one.id => "No", field_two.id => "Yes2" })
      user_two.info.merge(fields: [field_one], form_data: { field_one.id => "Yes" })
      user_three.info.merge(fields: [field_one, field_two], form_data: { field_one.id => "Yes", field_two.id => "No2" })
      user_four.info.merge(fields: [field_one, field_two], form_data: { field_one.id => "Yes", field_two.id => "No2" })
      [user_one, user_two, user_three, user_four].each(&:save!)

      RebuildElasticsearchIndexJob.perform_now(model_name: 'User', enterprise: enterprise)
      User.__elasticsearch__.refresh_index!(index: User.es_index_name(enterprise: enterprise))
    end

    context "and have no aggregation, segment or group" do
      it "returns all users with selected field" do
        data = field_one.highcharts_stats(aggr_field: nil, segments: [], groups: [])
        expect(data).to eq({
          series: [{ name: field_one.title, data: [{ name: "Yes", y: 3 }, { name: "No", y: 1 }] }]
        })
      end
    end

    context "and have an aggregation field" do
      it "returns all users with selected field aggregated by aggregation field" do
        data = field_two.highcharts_stats(aggr_field: field_one, segments: [], groups: [])
        expect(data).to eq({
          series: [{ name: "Yes", data: [2, 0] }, { name: "No", data: [0, 1] }],
          categories: ["No2", "Yes2"],
          xAxisTitle: field_two.title
        })
      end
    end

    context "and have segments" do
      it "returns all users with selected field and segments" do
        data = field_one.highcharts_stats(aggr_field: nil, segments: Segment.where(id: segment_one), groups: [])
        expect(data).to eq({
          series: [{ name: field_one.title, data: [{ name: "Yes", y: 2 }, { name: "No", y: 1 }] }]
        })
      end
    end

    context "and have groups" do
      it "returns all users with selected field and groups" do
        data = field_one.highcharts_stats(aggr_field: nil, segments: [], groups: Group.where(id: group))
        expect(data).to eq({
          series: [{ name: field_one.title, data: [{ name: "Yes", y: 2 }, { name: "No", y: 1 }] }]
        })
      end
    end

    context "and have aggregation, segments and groups" do
      it "returns all users with selected field, aggregated by field and have segments and filters" do
        data = field_one.highcharts_stats(aggr_field: field_two, segments: Segment.where(id: segment_two), groups: Group.where(id: group))
        expect(data).to eq({
          series: [{ name: "No2", data: [1, 0] }, { name: "Yes2", data: [0, 0] }],
          categories: ["Yes", "No"],
          xAxisTitle: field_one.title
        })
      end
    end

    context "and is aggregated by timeseries" do
      it "returns a timeseries with all users aggregated by created_at" do
        data = field_one.highcharts_timeseries(segments: [], groups: [])
        expect(data).to eq([
          {
            name: "Yes",
            data: [
              ["#{DateTime.parse(user_two.created_at.strftime("%Y-%m-%d")).to_i}000".to_i, 1],
              ["#{DateTime.parse(user_three.created_at.strftime("%Y-%m-%d")).to_i}000".to_i, 2]
            ]
          },
          {
            name: "No",
            data: [
              ["#{DateTime.parse(user_one.created_at.strftime("%Y-%m-%d")).to_i}000".to_i, 1]
            ]
          }
        ])
      end
    end
  end
end
