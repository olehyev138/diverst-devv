require 'rails_helper'

RSpec.describe DateField, type: :model do
  
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
      xit "returns all users with selected field" do
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
      xit "returns all users with selected field and segments" do
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
      xit "returns all users with selected field and groups" do
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
      xit "returns all users with selected field, aggregated by field and have segments and filters" do
        data = field_one.highcharts_stats(segments: Segment.where(id: segment_two), groups: Group.where(id: group))
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
  end
  
  describe "#string_value" do
    it "returns nil" do
      value = DateField.new.string_value(nil)
      expect(value).to eq('-')
    end
  end
  
  describe "#process_field_value" do
    it "returns nil" do
      value = DateField.new.process_field_value("")
      expect(value).to be(nil)
    end
    
    it "returns formatted date" do
      date = "2017-11-01"
      value = DateField.new.process_field_value(date)
      expect(value).to eq(Time.strptime(date, '%F'))
    end
  end

  describe "#deserialize_value" do
    it "returns nil" do
      value = DateField.new.deserialize_value(nil)
      expect(value).to be(nil)
    end
    
    it "returns date" do
      date = DateTime.now
      value = DateField.new.deserialize_value(date)
      expect(value).to eq(Time.at(date))
    end
  end
  
  describe "#csv_value" do
    it "returns nil" do
      value = DateField.new.csv_value(nil)
      expect(value).to eq('')
    end
    
    it "returns date" do
      date = DateTime.now
      value = DateField.new.csv_value(date)
      expect(value).to eq(date.strftime('%F'))
    end
  end
  
  describe "#match_score_between" do
    it "returns nil" do
      enterprise = create(:enterprise)
      date_field = DateField.new(:type => "DateField", :title => "Date of birth", :enterprise => enterprise)
      date_field.save!
      user_1 = create(:user, :data => "{\"#{date_field.id}\":-1641600}", :enterprise => enterprise)
      user_2 = create(:user, :data => "{\"#{date_field.id}\":-1641600}", :enterprise => enterprise)
      create_list(:user, 8, :data => "{\"#{date_field.id}\":-1641600}", :enterprise => enterprise)
      match_score_between = date_field.match_score_between(user_1, user_2, enterprise.users)
      expect(match_score_between).to eq(nil)
    end
  end
  
  describe "#validates_rule_for_user" do
    it "returns true" do
      enterprise = create(:enterprise)
      date_field = DateField.new(:type => "DateField", :title => "Date of birth", :enterprise => enterprise)
      date_field.save!
      user_1 = create(:user, :data => "{\"#{date_field.id}\":-1641600}", :enterprise => enterprise)
      segment = create(:segment, :name => "Seniors", :enterprise => enterprise)
      segment_rule = create(:segment_rule, :segment_id => segment.id, :field_id => date_field.id, :operator => 1, :values => "[\"1968-02-03\"]")
      boolean = date_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      
      expect(boolean).to be(true)
    end
    
    it "returns false" do
      enterprise = create(:enterprise)
      date_field = DateField.new(:type => "DateField", :title => "Date of birth", :enterprise => enterprise)
      date_field.save!
      user_1 = create(:user, :data => "{\"#{date_field.id}\":-1641600}", :enterprise => enterprise)
      segment = create(:segment, :name => "Seniors", :enterprise => enterprise)
      segment_rule = create(:segment_rule, :segment_id => segment.id, :field_id => date_field.id, :operator => 1, :values => "[\"1998-02-03\"]")
      boolean = date_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      
      expect(boolean).to be(false)
    end
    
    it "returns true" do
      enterprise = create(:enterprise)
      date_field = DateField.new(:type => "DateField", :title => "Date of birth", :enterprise => enterprise)
      date_field.save!
      user_1 = create(:user, :data => "{\"#{date_field.id}\":-60307200}", :enterprise => enterprise)
      segment = create(:segment, :name => "Seniors", :enterprise => enterprise)
      segment_rule = create(:segment_rule, :segment_id => segment.id, :field_id => date_field.id, :operator => 0, :values => "[\"1968-02-03\"]")
      boolean = date_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      
      expect(boolean).to be(true)
    end
    
    it "returns false" do
      enterprise = create(:enterprise)
      date_field = DateField.new(:type => "DateField", :title => "Date of birth", :enterprise => enterprise)
      date_field.save!
      user_1 = create(:user, :data => "{\"#{date_field.id}\":-60220800}", :enterprise => enterprise)
      segment = create(:segment, :name => "Seniors", :enterprise => enterprise)
      segment_rule = create(:segment_rule, :segment_id => segment.id, :field_id => date_field.id, :operator => 0, :values => "[\"1968-02-03\"]")
      boolean = date_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      
      expect(boolean).to be(false)
    end
    
    it "returns true" do
      enterprise = create(:enterprise)
      date_field = DateField.new(:type => "DateField", :title => "Date of birth", :enterprise => enterprise)
      date_field.save!
      user_1 = create(:user, :data => "{\"#{date_field.id}\":-691372800}", :enterprise => enterprise)
      segment = create(:segment, :name => "Seniors", :enterprise => enterprise)
      segment_rule = create(:segment_rule, :segment_id => segment.id, :field_id => date_field.id, :operator => 2, :values => "[\"1968-02-03\"]")
      boolean = date_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      
      expect(boolean).to be(true)
    end
    
    it "returns false" do
      enterprise = create(:enterprise)
      date_field = DateField.new(:type => "DateField", :title => "Date of birth", :enterprise => enterprise)
      date_field.save!
      user_1 = create(:user, :data => "{\"#{date_field.id}\":886550400}", :enterprise => enterprise)
      segment = create(:segment, :name => "Seniors", :enterprise => enterprise)
      segment_rule = create(:segment_rule, :segment_id => segment.id, :field_id => date_field.id, :operator => 2, :values => "[\"1968-02-03\"]")
      boolean = date_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      
      expect(boolean).to be(false)
    end
    
    it "returns true" do
      enterprise = create(:enterprise)
      date_field = DateField.new(:type => "DateField", :title => "Date of birth", :enterprise => enterprise)
      date_field.save!
      user_1 = create(:user, :data => "{\"#{date_field.id}\":886550400}", :enterprise => enterprise)
      segment = create(:segment, :name => "Seniors", :enterprise => enterprise)
      segment_rule = create(:segment_rule, :segment_id => segment.id, :field_id => date_field.id, :operator => 3, :values => "[\"1968-02-03\"]")
      boolean = date_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      
      expect(boolean).to be(true)
    end
    
    it "returns false" do
      enterprise = create(:enterprise)
      date_field = DateField.new(:type => "DateField", :title => "Date of birth", :enterprise => enterprise)
      date_field.save!
      user_1 = create(:user, :data => "{\"#{date_field.id}\":-60307200}", :enterprise => enterprise)
      segment = create(:segment, :name => "Seniors", :enterprise => enterprise)
      segment_rule = create(:segment_rule, :segment_id => segment.id, :field_id => date_field.id, :operator => 3, :values => "[\"1968-02-03\"]")
      boolean = date_field.validates_rule_for_user?(rule: segment_rule, user: user_1)
      
      expect(boolean).to be(false)
    end
  end
  
end
