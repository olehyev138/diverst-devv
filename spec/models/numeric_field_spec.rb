require 'rails_helper'

RSpec.describe NumericField, type: :model do
  context "when getting data" do
    let!(:field_one) { NumericField.create(attributes_for(:numeric_field)) }
    let!(:field_two) { NumericField.create(attributes_for(:numeric_field)) }

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
      user_one.info.merge(fields: [field_one, field_two], form_data: { field_one.id => 10, field_two.id => 20 })
      user_two.info.merge(fields: [field_one], form_data: { field_one.id => 30 })
      user_three.info.merge(fields: [field_one, field_two], form_data: { field_one.id => 10, field_two.id => 20 })
      user_four.info.merge(fields: [field_one, field_two], form_data: { field_one.id => 60, field_two.id => 60 })
      [user_one, user_two, user_three, user_four].each(&:save!)

      RebuildElasticsearchIndexJob.perform_now(model_name: 'User', enterprise: enterprise)
      User.__elasticsearch__.refresh_index!(index: User.es_index_name(enterprise: enterprise))
    end

    context "and have no aggregation, segment or group" do
      it "returns all users with selected field" do
        data = field_one.highcharts_stats(segments: [], groups: [])
        expect(data).to eq({
          series: [{ name: field_one.title, data: [2, 0, 1, 0, 1] }],
          categories: ["10-20", "20-30", "30-40", "40-50", "50-61"],
          xAxisTitle: field_one.title
        })
      end
    end

    context "and have segments" do
      it "returns all users with selected field and segments" do
        data = field_one.highcharts_stats(segments: Segment.where(id: segment_one), groups: [])
        expect(data).to eq({
          series: [{ name: field_one.title, data: [2, 0, 0, 0, 1] }],
          categories: ["10-20", "20-30", "30-40", "40-50", "50-61"],
          xAxisTitle: field_one.title
        })
      end
    end

    context "and have groups" do
      it "returns all users with selected field and groups" do
        data = field_one.highcharts_stats(segments: [], groups: Group.where(id: group))
        expect(data).to eq({
          series: [{ name: field_one.title, data: [1, 0, 1, 0, 1] }],
          categories: ["10-20", "20-30", "30-40", "40-50", "50-61"],
          xAxisTitle: field_one.title
        })
      end
    end

    context "and have segments and groups" do
      it "returns all users with selected field, aggregated by field and have segments and filters" do
        data = field_one.highcharts_stats(segments: Segment.where(id: segment_two), groups: Group.where(id: group))
        expect(data).to eq({
          series: [{ name: field_one.title, data: [2, 0, 1, 0, 1] }],
          categories: ["10-20", "20-30", "30-40", "40-50", "50-61"],
          xAxisTitle: field_one.title
        })
      end
    end
  end
end
