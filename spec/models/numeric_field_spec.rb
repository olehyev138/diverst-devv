require 'rails_helper'

RSpec.describe NumericField, type: :model do
  context "when getting data" do
    let!(:field_one) { NumericField.create(attributes_for(:numeric_field)) }
    let!(:field_two) { NumericField.create(attributes_for(:numeric_field)) }

    let!(:enterprise) { create(:enterprise) }

    let!(:group) { build(:group, enterprise: enterprise) }

    let!(:segment_one) { build(:segment, enterprise: enterprise) }
    let!(:segment_two) { build(:segment, enterprise: enterprise) }

    let!(:user_one) { create(:user, enterprise: enterprise, groups: [group],
      segments: [segment_one], created_at: Date.yesterday) }
    let!(:user_two) { create(:user, enterprise: enterprise, groups: [group],
      segments: [segment_two], created_at: Date.yesterday) }
    let!(:user_three) { create(:user, enterprise: enterprise,
      segments: [segment_one, segment_two], created_at: Date.today) }
    let!(:user_four) { create(:user, enterprise: enterprise, groups: [group],
      segments: [segment_one, segment_two], created_at: Date.today) }

    before do
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
  
  describe "#string_value" do
    it "returns nil" do
      value = NumericField.new.string_value(nil)
      expect(value).to eq('-')
    end

    it "returns string" do
      value = NumericField.new.string_value("1")
      expect(value).to eq("1")
    end
  end
  
  describe "#serialize_value" do
    it "returns int" do
      value = NumericField.new.serialize_value("1")
      expect(value).to eq(1)
    end
  end
  
  describe "#match_score_between" do
    it "returns 0.0" do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(:type => "NumericField", :title => "Seniority (in years)", :min => 0, :max => 40, :enterprise => enterprise)
      numeric_field.save!
      user_1 = create(:user, :data => "{\"#{numeric_field.id}\":2}", :enterprise => enterprise)
      user_2 = create(:user, :data => "{\"#{numeric_field.id}\":2}", :enterprise => enterprise)
      create_list(:user, 8, :data => "{\"#{numeric_field.id}\":1}", :enterprise => enterprise)
      match_score_between = numeric_field.match_score_between(user_1, user_2, enterprise.users)
      expect(match_score_between).to eq(0.0)
    end
  end
  
  describe "#validates_rule_for_user" do
    it "returns true" do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(:type => "NumericField", :title => "Seniority (in years)", :min => 0, :max => 40, :enterprise => enterprise)
      numeric_field.save!
      user_1 = create(:user, :data => "{\"#{numeric_field.id}\":21}", :enterprise => enterprise)
      segment = create(:segment, :name => "Seniors", :enterprise => enterprise)
      segment_rule = create(:segment_rule, :segment_id => segment.id, :field_id => numeric_field.id, :operator => 1, :values => "[\"20\"]")
      boolean = numeric_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      expect(boolean).to be(true)
    end
    
    it "returns false" do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(:type => "NumericField", :title => "Seniority (in years)", :min => 0, :max => 40, :enterprise => enterprise)
      numeric_field.save!
      user_1 = create(:user, :data => "{\"#{numeric_field.id}\":19}", :enterprise => enterprise)
      segment = create(:segment, :name => "Seniors", :enterprise => enterprise)
      segment_rule = create(:segment_rule, :segment_id => segment.id, :field_id => numeric_field.id, :operator => 1, :values => "[\"20\"]")
      boolean = numeric_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      expect(boolean).to be(false)
    end
    
    it "returns true" do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(:type => "NumericField", :title => "Seniority (in years)", :min => 0, :max => 40, :enterprise => enterprise)
      numeric_field.save!
      user_1 = create(:user, :data => "{\"#{numeric_field.id}\":20}", :enterprise => enterprise)
      segment = create(:segment, :name => "Seniors", :enterprise => enterprise)
      segment_rule = create(:segment_rule, :segment_id => segment.id, :field_id => numeric_field.id, :operator => 0, :values => "[\"20\"]")
      boolean = numeric_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      expect(boolean).to be(true)
    end
    
    it "returns false" do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(:type => "NumericField", :title => "Seniority (in years)", :min => 0, :max => 40, :enterprise => enterprise)
      numeric_field.save!
      user_1 = create(:user, :data => "{\"#{numeric_field.id}\":19}", :enterprise => enterprise)
      segment = create(:segment, :name => "Seniors", :enterprise => enterprise)
      segment_rule = create(:segment_rule, :segment_id => segment.id, :field_id => numeric_field.id, :operator => 0, :values => "[\"20\"]")
      boolean = numeric_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      expect(boolean).to be(false)
    end
    
    it "returns true" do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(:type => "NumericField", :title => "Seniority (in years)", :min => 0, :max => 40, :enterprise => enterprise)
      numeric_field.save!
      user_1 = create(:user, :data => "{\"#{numeric_field.id}\":19}", :enterprise => enterprise)
      segment = create(:segment, :name => "Seniors", :enterprise => enterprise)
      segment_rule = create(:segment_rule, :segment_id => segment.id, :field_id => numeric_field.id, :operator => 2, :values => "[\"20\"]")
      boolean = numeric_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      expect(boolean).to be(true)
    end
    
    it "returns false" do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(:type => "NumericField", :title => "Seniority (in years)", :min => 0, :max => 40, :enterprise => enterprise)
      numeric_field.save!
      user_1 = create(:user, :data => "{\"#{numeric_field.id}\":21}", :enterprise => enterprise)
      segment = create(:segment, :name => "Seniors", :enterprise => enterprise)
      segment_rule = create(:segment_rule, :segment_id => segment.id, :field_id => numeric_field.id, :operator => 2, :values => "[\"20\"]")
      boolean = numeric_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      expect(boolean).to be(false)
    end
    
    it "returns true" do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(:type => "NumericField", :title => "Seniority (in years)", :min => 0, :max => 40, :enterprise => enterprise)
      numeric_field.save!
      user_1 = create(:user, :data => "{\"#{numeric_field.id}\":19}", :enterprise => enterprise)
      segment = create(:segment, :name => "Seniors", :enterprise => enterprise)
      segment_rule = create(:segment_rule, :segment_id => segment.id, :field_id => numeric_field.id, :operator => 3, :values => "[\"20\"]")
      boolean = numeric_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      expect(boolean).to be(true)
    end
    
    it "returns false" do
      enterprise = create(:enterprise)
      numeric_field = NumericField.new(:type => "NumericField", :title => "Seniority (in years)", :min => 0, :max => 40, :enterprise => enterprise)
      numeric_field.save!
      user_1 = create(:user, :data => "{\"#{numeric_field.id}\":20}", :enterprise => enterprise)
      segment = create(:segment, :name => "Seniors", :enterprise => enterprise)
      segment_rule = create(:segment_rule, :segment_id => segment.id, :field_id => numeric_field.id, :operator => 3, :values => "[\"20\"]")
      boolean = numeric_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      expect(boolean).to be(false)
    end
  end
end
