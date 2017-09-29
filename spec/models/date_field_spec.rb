require 'rails_helper'

RSpec.describe DateField, elasticsearch: true, type: :model, :skip => "Need to fix - written by gabriel" do
  context "when getting data" do
    let!(:field_one) { DateField.create(attributes_for(:date_field)) }
    let!(:field_two) { DateField.create(attributes_for(:date_field)) }

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
      user_one.info.merge(fields: [field_one, field_two], form_data: { field_one.id => Date.today.to_s, field_two.id => (Date.today + 20.days).to_s })
      user_two.info.merge(fields: [field_one], form_data: { field_one.id => (Date.today + 5.days).to_s })
      user_three.info.merge(fields: [field_one, field_two], form_data: { field_one.id => (Date.today + 10.days).to_s, field_two.id => (Date.today + 25.days).to_s })
      user_four.info.merge(fields: [field_one, field_two], form_data: { field_one.id => (Date.today + 15.days).to_s, field_two.id => (Date.today + 30.days).to_s })
      [user_one, user_two, user_three, user_four].each(&:save!)

      RebuildElasticsearchIndexJob.perform_now(model_name: 'User', enterprise: enterprise)
      User.__elasticsearch__.refresh_index!(index: User.es_index_name(enterprise: enterprise))
    end

    context "and have no aggregation, segment or group" do
      it "returns all users with selected field" do
        data = field_one.highcharts_stats(segments: [], groups: [])
        expect(data).to eq({
          series: [{ name: field_one.title, data: [1, 1, 0, 1, 1] }],
          categories: [
            "#{ Date.today.strftime("%m/%d/%Y") }-#{ (Date.today + 3.days).strftime("%m/%d/%Y") }",
            "#{ (Date.today + 3.days).strftime("%m/%d/%Y") }-#{ (Date.today + 6.days).strftime("%m/%d/%Y") }",
            "#{ (Date.today + 6.days).strftime("%m/%d/%Y") }-#{ (Date.today + 9.days).strftime("%m/%d/%Y") }",
            "#{ (Date.today + 9.days).strftime("%m/%d/%Y") }-#{ (Date.today + 12.days).strftime("%m/%d/%Y") }",
            "#{ (Date.today + 12.days).strftime("%m/%d/%Y") }-#{ (Date.today + 15.days).strftime("%m/%d/%Y") }"
          ],
          xAxisTitle: field_one.title
        })
      end
    end

    context "and have segments" do
      it "returns all users with selected field and segments" do
        data = field_one.highcharts_stats(segments: Segment.where(id: segment_one), groups: [])
        expect(data).to eq({
          series: [{ name: field_one.title, data: [1, 0, 0, 1, 1] }],
          categories: [
            "#{ Date.today.strftime("%m/%d/%Y") }-#{ (Date.today + 3.days).strftime("%m/%d/%Y") }",
            "#{ (Date.today + 3.days).strftime("%m/%d/%Y") }-#{ (Date.today + 6.days).strftime("%m/%d/%Y") }",
            "#{ (Date.today + 6.days).strftime("%m/%d/%Y") }-#{ (Date.today + 9.days).strftime("%m/%d/%Y") }",
            "#{ (Date.today + 9.days).strftime("%m/%d/%Y") }-#{ (Date.today + 12.days).strftime("%m/%d/%Y") }",
            "#{ (Date.today + 12.days).strftime("%m/%d/%Y") }-#{ (Date.today + 15.days).strftime("%m/%d/%Y") }"
          ],
          xAxisTitle: field_one.title
        })
      end
    end

    context "and have groups" do
      it "returns all users with selected field and groups" do
        data = field_one.highcharts_stats(segments: [], groups: Group.where(id: group))
        expect(data).to eq({
          series: [{ name: field_one.title, data: [1, 1, 0, 0, 1] }],
          categories: [
            "#{ Date.today.strftime("%m/%d/%Y") }-#{ (Date.today + 3.days).strftime("%m/%d/%Y") }",
            "#{ (Date.today + 3.days).strftime("%m/%d/%Y") }-#{ (Date.today + 6.days).strftime("%m/%d/%Y") }",
            "#{ (Date.today + 6.days).strftime("%m/%d/%Y") }-#{ (Date.today + 9.days).strftime("%m/%d/%Y") }",
            "#{ (Date.today + 9.days).strftime("%m/%d/%Y") }-#{ (Date.today + 12.days).strftime("%m/%d/%Y") }",
            "#{ (Date.today + 12.days).strftime("%m/%d/%Y") }-#{ (Date.today + 15.days).strftime("%m/%d/%Y") }"
          ],
          xAxisTitle: field_one.title
        })
      end
    end

    context "and have segments and groups" do
      it "returns all users with selected field, aggregated by field and have segments and filters" do
        data = field_one.highcharts_stats(segments: Segment.where(id: segment_two), groups: Group.where(id: group))
        expect(data).to eq({
          series: [{ name: field_one.title, data: [0, 1, 0, 0, 1] }],
          categories: [
            "#{ Date.today.strftime("%m/%d/%Y") }-#{ (Date.today + 3.days).strftime("%m/%d/%Y") }",
            "#{ (Date.today + 3.days).strftime("%m/%d/%Y") }-#{ (Date.today + 6.days).strftime("%m/%d/%Y") }",
            "#{ (Date.today + 6.days).strftime("%m/%d/%Y") }-#{ (Date.today + 9.days).strftime("%m/%d/%Y") }",
            "#{ (Date.today + 9.days).strftime("%m/%d/%Y") }-#{ (Date.today + 12.days).strftime("%m/%d/%Y") }",
            "#{ (Date.today + 12.days).strftime("%m/%d/%Y") }-#{ (Date.today + 15.days).strftime("%m/%d/%Y") }"
          ],
          xAxisTitle: field_one.title
        })
      end
    end
  end
end
