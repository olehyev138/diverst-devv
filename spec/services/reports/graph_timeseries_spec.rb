require 'rails_helper'

RSpec.describe Reports::GraphTimeseries do
  include ActiveJob::TestHelper
  
  before {
    perform_enqueued_jobs do
      enterprise = create(:enterprise)
      select_field = SelectField.new(:type => "SelectField", :title => "Gender", :options_text => "Male\nFemale", :container => enterprise)
      select_field.save!
      
      segment = create(:segment, :enterprise => enterprise, :created_at => 1.day.ago)
      create(:segment_rule, :segment => segment, :field => select_field, :operator => 4, :values => "[\"Female\"]", :created_at => 1.day.ago)
    
      user = create(:user, :enterprise => enterprise, :data => "{\"#{select_field.id}\":[\"Female\"]}", :active => true, :created_at => 1.day.ago)
      create(:users_segment, :user => user, :segment => segment)
      
      group = create(:group, :enterprise => enterprise, :created_at => 1.day.ago)
      create(:user_group, :user => user, :group => group, :accepted_member => true, :created_at => 1.day.ago)
      
      collection = create(:metrics_dashboard, :enterprise => enterprise, :segments => enterprise.segments, :groups => enterprise.groups)
      @graph = create(:graph, :field => select_field, :collection => collection)
      
      User.__elasticsearch__.refresh_index!(index: User.es_index_name(enterprise: enterprise))
    end
  }
  
  describe "#get_header" do
    it "returns an array with length of 2" do
      expect(Reports::GraphTimeseries.new(@graph).get_header.length).to eq(2)
    end
  end
  
  describe "#get_body" do
    it "returns an array with length of 1" do
      expect(Reports::GraphTimeseries.new(@graph).get_body.length).to eq(1)
    end
  end
end
