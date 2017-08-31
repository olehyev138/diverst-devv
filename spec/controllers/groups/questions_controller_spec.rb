require 'rails_helper'

RSpec.describe Groups::QuestionsController, type: :controller do
    let(:user) { create :user }
    let(:group){ create(:group, enterprise: user.enterprise) }
    
    login_user_from_let
    
    describe 'GET#index' do
        it "gets the questions" do
            get :index, group_id: group.id
            expect(response).to be_success
        end
    end
    
    describe 'GET#survey' do
        context "with no user group" do
            before {get :survey, group_id: group.id}
            
            it "redirects" do
                expect(response).to redirect_to(group)
            end
            
            it "flashes" do
                expect(flash[:notice]).to eq("Your have to join group before taking it's survey")
            end
        end
        
        it "gets the survey" do
            # create the user group
            create :user_group, group: group, user: user
            
            get :survey, group_id: group.id
            expect(response).to be_success
        end
    end
    
    describe 'GET#submit_survey' do
        
        before :each do
            # create the user group
            create :user_group, group: group, user: user
            patch :submit_survey, group_id: group.id, "custom-fields": {}
        end

        it "redirects" do
            expect(response).to redirect_to(group)
        end
        
        it "flashes" do
            expect(flash[:notice]).to eq("Your response was saved")
        end
    end
    
    describe 'GET#export_csv' do
        it "gets the csv file" do
            get :export_csv, group_id: group.id, format: :csv
            expect(response).to be_success
        end
    end
end