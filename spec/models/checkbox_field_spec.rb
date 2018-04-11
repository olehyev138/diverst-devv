require 'rails_helper'

RSpec.describe CheckboxField, type: :model do
  context "when getting data" do
    let!(:field_one) { CheckboxField.create(attributes_for(:checkbox_field)) }
    let!(:field_two) { CheckboxField.create(attributes_for(:checkbox_field, options_text: "Yes2\nNo2")) }

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
      user_one.info.merge(fields: [field_one, field_two], form_data: { field_one.id => ["No", "Yes"], field_two.id => "Yes2" })
      user_two.info.merge(fields: [field_one], form_data: { field_one.id => "Yes" })
      user_three.info.merge(fields: [field_one, field_two], form_data: { field_one.id => "Yes", field_two.id => ["No2", "Yes2"] })
      user_four.info.merge(fields: [field_one, field_two], form_data: { field_one.id => ["Yes", "No"], field_two.id => "No2" })
      [user_one, user_two, user_three, user_four].each(&:save!)

      RebuildElasticsearchIndexJob.perform_now(model_name: 'User', enterprise: enterprise)
      User.__elasticsearch__.refresh_index!(index: User.es_index_name(enterprise: enterprise))
    end

    context "and have no aggregation, segment or group" do
      it "returns all users with selected field" do
        data = field_one.highcharts_stats(aggr_field: nil, segments: [], groups: [])
        expect(data).to eq({
          series: [{ name: field_one.title, data: [{ name: "Yes", y: 4 }, { name: "No", y: 2 }] }]
        })
      end
    end

    context "and have an aggregation field" do
      it "returns all users with selected field aggregated by aggregation field" do
        data = field_two.highcharts_stats(aggr_field: field_one, segments: [], groups: [])
        expect(data).to eq({
          series: [{ name: "Yes", data: [2, 2] }, { name: "No", data: [1, 1] }],
          categories: ["No2", "Yes2"],
          xAxisTitle: field_two.title
        })
      end
    end

    context "and have segments" do
      it "returns all users with selected field and segments" do
        data = field_one.highcharts_stats(aggr_field: nil, segments: Segment.where(id: segment_one), groups: [])
        expect(data).to eq({
          series: [{ name: field_one.title, data: [{ name: "Yes", y: 3 }, { name: "No", y: 2 }] }]
        })
      end
    end

    context "and have groups" do
      it "returns all users with selected field and groups" do
        data = field_one.highcharts_stats(aggr_field: nil, segments: [], groups: Group.where(id: group))
        expect(data).to eq({
          series: [{ name: field_one.title, data: [{ name: "Yes", y: 3 }, { name: "No", y: 2 }] }]
        })
      end
    end

    context "and have aggregation, segments and groups" do
      it "returns all users with selected field, aggregated by field and have segments and filters" do
        data = field_one.highcharts_stats(aggr_field: field_two, segments: Segment.where(id: segment_two), groups: Group.where(id: group))
        expect(data).to eq({
          series: [{ name: "No2", data: [2, 1] }, { name: "Yes2", data: [2, 1] }],
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
              ["#{DateTime.parse(user_two.created_at.strftime("%Y-%m-%d")).to_i}000".to_i, 2],
              ["#{DateTime.parse(user_three.created_at.strftime("%Y-%m-%d")).to_i}000".to_i, 2]
            ]
          },
          {
            name: "No",
            data: [
              ["#{DateTime.parse(user_one.created_at.strftime("%Y-%m-%d")).to_i}000".to_i, 1],
              ["#{DateTime.parse(user_three.created_at.strftime("%Y-%m-%d")).to_i}000".to_i, 1]
            ]
          }
        ])
      end
    end
  end
  
  describe "#string_value" do
    it "returns nil" do
      value = CheckboxField.new.string_value(nil)
      expect(value).to eq('-')
    end
    
    it "returns nil" do
      value = CheckboxField.new.string_value([])
      expect(value).to eq("")
    end
    
    it "returns long string" do
      value = CheckboxField.new.string_value(["English", "Mandarin", "Spanish", "Hind", "Arabic", "Russian"])
      expect(value).to eq("English, Mandarin, Spanish, Hind, Arabic, Russian")
    end
  end
  
  describe "#csv_value" do
    it "returns nil" do
      value = CheckboxField.new.csv_value(nil)
      expect(value).to eq("")
    end
    
    it "returns nil" do
      value = CheckboxField.new.csv_value([])
      expect(value).to eq("")
    end
    
    it "returns long string" do
      value = CheckboxField.new.csv_value(["English", "Mandarin", "Spanish", "Hind", "Arabic", "Russian"])
      expect(value).to eq("English,Mandarin,Spanish,Hind,Arabic,Russian")
    end
  end
  
  describe "#popularity_for_no_option" do
    it "returns 1" do
      enterprise = create(:enterprise)
      checkbox_field = CheckboxField.new(:type => "CheckboxField", :title => "Spoken languages", :options_text => "English\nMandarin\nSpanish\nHindi\nArabic\nRussian\nPortuguese", :enterprise => enterprise)
      checkbox_field.save!
      user = create(:user)
      popularity = checkbox_field.popularity_for_no_option([user])
      expect(popularity).to eq(1)
    end
    
    it "returns 0.5" do
      enterprise = create(:enterprise)
      checkbox_field = CheckboxField.new(:type => "CheckboxField", :title => "Spoken languages", :options_text => "English\nMandarin\nSpanish\nHindi\nArabic\nRussian\nPortuguese", :enterprise => enterprise)
      checkbox_field.save!
      user_1 = create(:user)
      user_2 = create(:user, :data => "{\"#{checkbox_field.id}\":\"Mandarin\"}")
      popularity = checkbox_field.popularity_for_no_option([user_1, user_2])
      expect(popularity).to eq(0.5)
    end
  end
  
  describe "#popularity_for_value" do
    it "returns 1" do
      enterprise = create(:enterprise)
      checkbox_field = CheckboxField.new(:type => "CheckboxField", :title => "Spoken languages", :options_text => "English\nMandarin\nSpanish\nHindi\nArabic\nRussian\nPortuguese", :enterprise => enterprise)
      checkbox_field.save!
      user = create(:user, :data => "{\"#{checkbox_field.id}\":[\"English\"]}")
      popularity = checkbox_field.popularity_for_value("English", [user])
      expect(popularity).to eq(1)
    end
    
    it "returns 0.5" do
      enterprise = create(:enterprise)
      checkbox_field = CheckboxField.new(:type => "CheckboxField", :title => "Spoken languages", :options_text => "English\nMandarin\nSpanish\nHindi\nArabic\nRussian\nPortuguese", :enterprise => enterprise)
      checkbox_field.save!
      user_1 = create(:user, :data => "{\"#{checkbox_field.id}\":\"English\"}")
      user_2 = create(:user, :data => "{\"#{checkbox_field.id}\":\"Spanish\"}")
      popularity = checkbox_field.popularity_for_value("English", [user_1, user_2])
      expect(popularity).to eq(0.5)
    end
  end
  
  describe "#user_popularity" do
    it "returns 0.1" do
      enterprise = create(:enterprise)
      checkbox_field = CheckboxField.new(:type => "CheckboxField", :title => "Spoken languages", :options_text => "English\nMandarin\nSpanish\nHindi\nArabic\nRussian\nPortuguese", :enterprise => enterprise)
      checkbox_field.save!
      user_1 = create(:user, :data => "{\"#{checkbox_field.id}\":[\"English\"]}", :enterprise => enterprise)
      create_list(:user, 9, :data => "{\"#{checkbox_field.id}\":[\"Spanish\"]}", :enterprise => enterprise)
      popularity = checkbox_field.user_popularity(user_1, enterprise.users)
      expect(popularity).to eq(0.1)
    end
  end
  
  describe "#match_score_between" do
    it "returns 0.5" do
      enterprise = create(:enterprise)
      checkbox_field = CheckboxField.new(:type => "CheckboxField", :title => "Spoken languages", :options_text => "English\nMandarin\nSpanish\nHindi\nArabic\nRussian\nPortuguese", :enterprise => enterprise)
      checkbox_field.save!
      user_1 = create(:user, :data => "{\"#{checkbox_field.id}\":[\"English\"]}", :enterprise => enterprise)
      user_2 = create(:user, :data => "{\"#{checkbox_field.id}\":[\"Mandarin\"]}", :enterprise => enterprise)
      create_list(:user, 8, :data => "{\"#{checkbox_field.id}\":[\"Mandarin\"]}", :enterprise => enterprise)
      match_score_between = checkbox_field.match_score_between(user_1, user_2, enterprise.users)
      expect(match_score_between).to eq(0.8)
    end
  end
end
