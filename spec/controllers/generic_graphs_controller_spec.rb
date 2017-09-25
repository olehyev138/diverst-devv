require 'rails_helper'

RSpec.describe GenericGraphsController, type: :controller, :skip => true do
    let(:enterprise){ create(:enterprise, cdo_name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:field){create(:field, type: "NumericField", container_id: enterprise.id, container_type: "Enterprise", elasticsearch_only: false)}
    
    describe "GET#group_population" do
        describe "with logged in user" do
            login_user_from_let

            context "when format is json" do
                
                before {get :group_population, format: :json}
                
                it "returns success" do
                    expect(response).to be_success
                end
            end
            
            context "when format is csv" do
                
                before {get :group_population, format: :csv}
                
                it "returns success" do
                    expect(response).to be_success
                end
            end
        end
    end
    
    describe "GET#segment_population" do
        describe "with logged in user" do
            login_user_from_let
            
            context "when format is json" do
                
                before {get :segment_population, format: :json}
                
                it "returns success" do
                    expect(response).to be_success
                end
                
                it "returns correct data" do
                    data = JSON.parse(response.body)
                    expect(data["type"]).to eq("bar")
                    expect(data["highcharts"]["series"][0]["name"]).to eq("Number of users")
                    expect(data["highcharts"]["series"][0]["colorByPoint"]).to eq(true)
                    expect(data["highcharts"]["series"][0]["data"].length).to eq(0)
                    expect(data["highcharts"]["drilldowns"].length).to eq(0)
                    expect(data["highcharts"]["xAxisTitle"]).to eq("Segment")
                    expect(data["hasAggregation"]).to eq(false)
                end
            end
            
            context "when format is csv" do
                
                before {get :segment_population, format: :csv}
                
                it "returns success" do
                    expect(response).to be_success
                end
                
                it "returns correct data" do
                    expect(response.body).to eq("Number of users by segment\n")
                end
            end
        end
    end
    
    describe "GET#events_created" do
        describe "with logged in user" do
            login_user_from_let

            context "when format is json" do
                before {get :events_created, format: :json}
                
                it "returns success" do
                    expect(response).to be_success
                end
            end
            
            context "when format is csv" do
                
                before {get :events_created, format: :csv}
                
                it "returns success" do
                    expect(response).to be_success
                end
            end
        end
    end
    
    describe "GET#messages_sent" do
        describe "with logged in user" do
            login_user_from_let

            context "when format is json" do
                before {get :messages_sent, format: :json}
                
                it "returns success" do
                    expect(response).to be_success
                end
            end
            
            context "when format is csv" do
                
                before {get :messages_sent, format: :csv}
                
                it "returns success" do
                    expect(response).to be_success
                end
            end
            
        end
    end
end
