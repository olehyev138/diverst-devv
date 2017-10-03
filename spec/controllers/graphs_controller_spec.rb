require 'rails_helper'

RSpec.describe GraphsController, type: :controller do
    let(:enterprise){ create(:enterprise, cdo_name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:metrics_dashboard){create(:metrics_dashboard, enterprise_id: enterprise.id)}
    let(:poll){create(:poll, enterprise_id: enterprise.id)}
    let(:field1){create(:field, type: "NumericField")}
    let(:field2){create(:field, type: "NumericField")}
    let(:metrics_graph){create(:graph, collection: metrics_dashboard, field: field1)}
    let(:poll_graph){create(:graph, collection: poll, field: field2)}
    
    describe "GET#new" do
        describe "with logged in user" do
            login_user_from_let
            
            it "returns success" do
                get :new, :metrics_dashboard_id => metrics_dashboard.id
                expect(response).to be_success
            end
        end
    end
    
    describe "POST#create" do
        describe "with logged in user" do
            login_user_from_let
            
            context "when metrics_dashboard" do
                before {post :create, :metrics_dashboard_id => metrics_dashboard.id, :graph => {field_id: field1.id}}
                
                it "returns success" do
                    expect(response).to redirect_to metrics_dashboard
                end
                
                it 'creates new graph' do
                    expect(Graph.count).to eq(1)
                end
                
                it "flashes" do
                    expect(flash[:notice])
                end
            end
        end
    end
    
    describe "GET#index", :skip => "Missing a template" do
        describe "with logged in user" do
            login_user_from_let
            
            it "returns success" do
                get :index, :metrics_dashboard_id => metrics_dashboard.id
                expect(response).to be_success
            end
        end
    end
    
    describe "PATCH#update" do
        describe "with logged in user" do
            login_user_from_let
            
            context "when metrics_graph" do
                before {patch :update, :metrics_dashboard_id => metrics_dashboard.id, :id => metrics_graph.id, :graph => {field_id: field1.id}}
                
                it "returns success" do
                    expect(response).to redirect_to metrics_dashboard
                end
                
                it 'updates the graph' do
                    metrics_graph.reload
                    expect(metrics_graph.field_id).to eq(field1.id)
                end
                
                it "flashes" do
                    expect(flash[:notice])
                end
            end
        end
    end
    
    describe "DELETE#destroy" do
        describe "with logged in user" do
            
            login_user_from_let
            before {request.env["HTTP_REFERER"] = "back"}
            
            context "when metrics_graph" do
                before {delete :destroy, :metrics_dashboard_id => metrics_dashboard.id, :id => metrics_graph.id}
                
                it "returns success" do
                    expect(response).to redirect_to "back"
                end
            end
        end
    end
    
    describe "GET#data", :skip => "need to figure out how to work with elastisearch" do
        describe "with logged in user" do
            login_user_from_let
            
            it "returns success" do
                #get :data, :id => metrics_graph.id
                #expect(response).to be_success
            end
            
            it "returns success" do
                #get :data, :id => poll_graph.id
                #expect(response).to be_success
            end
        end
    end

    describe "GET#export_csv", :skip => "need to figure out how to work with elastisearch" do
        describe "with logged in user" do
            login_user_from_let
            
            it "returns success" do
                get :export_csv, :id => metrics_graph.id
                expect(response).to be_success
            end
            
            it "returns success" do
                get :export_csv, :id => poll_graph.id
                expect(response).to be_success
            end
        end
    end
end