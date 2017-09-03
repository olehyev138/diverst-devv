require 'rails_helper'

RSpec.describe Groups::FieldsController, type: :controller do
    let(:user) { create :user }
    let(:group){ create(:group, enterprise: user.enterprise) }
    let(:field){create(:field, type: "NumericField", container_id: group.id, container_type: "Group", elasticsearch_only: false)}
    
    login_user_from_let
    
    describe 'GET#time_series' do
        it "gets the charts" do
            get :time_series, group_id: group.id, id: field.id, format: :json
            expect(response).to be_success
        end
        
        it "gets the charts" do
            get :time_series, group_id: group.id, id: field.id, format: :csv
            expect(response).to be_success
        end
    end
end
