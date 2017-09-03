require 'rails_helper'

RSpec.describe Groups::EventsController, type: :controller do
    let(:user) { create :user }
    let(:group){ create(:group, enterprise: user.enterprise) }
    let(:initiative){ initiative_of_group(group) }
    
    login_user_from_let
    
    describe 'GET#index' do
        it "gets the events" do
            get :index, group_id: group.id
            expect(response).to be_success
        end
    end
    
    describe 'GET#calendar_data', :skip => "Missing Template" do
        it "gets the events" do
            get :calendar_data, group_id: group.id
            expect(response).to be_success
        end
    end
    
    describe 'GET#show' do
        it "gets the event" do
            get :show, group_id: group.id, :id => initiative.id
            expect(response).to be_success
        end
    end
    
    describe 'DELETE#destroy' do
        before {delete :destroy, group_id: group.id, :id => initiative.id}
        
        it "redirect_to index" do
            expect(response).to redirect_to action: :index
        end
        
        it "deletes the event" do
            expect(Initiative.where(:id => initiative.id).count).to eq(0)
        end
    end
    
    describe 'GET#export_ics' do
        it "gets the event" do
            get :export_ics, group_id: group.id, :id => initiative.id
            expect(response).to be_success
        end
    end
end
