require 'rails_helper'

RSpec.describe GenericGraphsController, type: :controller do
    let(:enterprise){ create(:enterprise, cdo_name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:field){create(:field, type: "NumericField", container_id: enterprise.id, container_type: "Enterprise", elasticsearch_only: false)}
    
    describe "GET#group_population" do
        describe "with logged in user" do
            login_user_from_let
            
            it "returns success" do
                get :group_population, format: :json
                expect(response).to be_success
            end
        end
    end
    
    describe "GET#segment_population" do
        describe "with logged in user" do
            login_user_from_let
            
            it "returns success" do
                get :segment_population, format: :json
                expect(response).to be_success
            end
        end
    end
    
    describe "GET#events_created" do
        describe "with logged in user" do
            login_user_from_let
            
            it "returns success" do
                get :events_created, format: :json
                expect(response).to be_success
            end
        end
    end
    
    describe "GET#messages_sent" do
        describe "with logged in user" do
            login_user_from_let
            
            it "returns success" do
                get :messages_sent, format: :json
                expect(response).to be_success
            end
        end
    end
end
