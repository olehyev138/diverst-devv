require 'rails_helper'

RSpec.describe Api::V1::GroupsController, type: :controller do
    let(:enterprise){ create(:enterprise) }
    let(:user){ create(:user, enterprise: enterprise, password: "password", first_name: "MICHAEL") }
    let(:group){ create(:group, enterprise: enterprise) }
    
    context "without authentication" do
    
        describe "GET#index" do
            it "gets the groups" do
                get :index
                expect(response).to_not be_success
                expect(response.status).to be(400)
            end
        end
        
        describe "GET#show" do
            it "gets the group" do
                get :show, :id => 1
                expect(response).to_not be_success
                expect(response.status).to be(400)
            end
        end
        
        describe "POST#create" do
            it "creates the group" do
                post :create
                expect(response).to_not be_success
                expect(response.status).to be(400)
            end
        end
        
        describe "PATCH#update" do
            it "updates the group" do
                patch :update, :id => 1
                expect(response).to_not be_success
                expect(response.status).to be(400)
            end
        end
        
        describe "DELETE#destroy" do
            it "deletes the group" do
                delete :destroy, :id => 1
                expect(response).to_not be_success
                expect(response.status).to be(400)
            end
        end
    end
    
    context "with authentication" do
        before :each do
            request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email, "password")
        end
    
        describe "GET#index" do
            it "gets the groups" do
                get :index
                expect(response).to be_success
                expect(response.status).to be(200)
            end
        end
        
        describe "GET#show" do
            it "gets the group" do
                get :show, :id => group.id
                expect(response).to be_success
            end
        end
        
        describe "POST#create" do
            it "creates the group" do
                post :create, { :group => FactoryGirl.attributes_for(:group) }
                expect(response.status).to eq 201
            end
        end
        
        describe "PATCH#update" do
            it "updates the group" do
                patch :update, :id => group.id, :group => {:name => "updated"}
                expect(response).to be_success
                expect(response.status).to be(200)
            end
        end
        
        describe "DELETE#destroy" do
            it "deletes the group" do
                delete :destroy, :id => group.id
                expect(response).to be_success
                expect(response.status).to be(204)
            end
        end
    end
end