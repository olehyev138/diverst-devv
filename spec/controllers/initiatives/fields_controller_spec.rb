require 'rails_helper'

RSpec.describe Initiatives::FieldsController, type: :controller do
    let(:user) { create :user }
    let(:group){ create(:group, enterprise: user.enterprise) }
    let(:initiative){ initiative_of_group(group) }
    let(:field) {create :field, container_id: initiative.id, container_type: "Initiative", elasticsearch_only: false}
    let(:initiative_field) {create :initiative_field, initiative: initiative, field: field}
    
    login_user_from_let
    
    describe 'GET#time_series' do
        it "gets the time_series" do
            get :time_series, group_id: group.id, initiative_id: initiative.id, id: field.id, format: :json
            expect(response).to be_success
        end
    end
end