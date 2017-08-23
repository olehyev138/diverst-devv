require 'rails_helper'

RSpec.describe Api::V1::GroupsController, type: :controller do
    let(:enterprise){ create(:enterprise) }
    let(:user){ create(:user, enterprise: enterprise) }
    
    describe "GET#index" do
        it "gets the groups" do
            get :index
            expect(response).to be_success
        end
    end
    
    describe "GET#show" do
        it "gets the group" do
            get :show, :id => 1
            expect(response).to be_success
        end
    end
    
    describe "POST#create" do
        it "creates the group" do
            post :create
            expect(response).to be_success
        end
    end
    
    describe "PATCH#update" do
        it "updates the group" do
            patch :update, :id => 1
            expect(response).to be_success
        end
    end
    
    describe "DELETE#destroy" do
        it "deletes the group" do
            delete :destroy, :id => 1
            expect(response).to be_success
        end
    end
end