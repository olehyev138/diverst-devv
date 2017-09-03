require 'rails_helper'

RSpec.describe SegmentsController, type: :controller do
    let(:enterprise){ create(:enterprise, cdo_name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:segment){ create(:segment, enterprise: enterprise) }
    
    login_user_from_let
    
    describe "GET#index" do
        it "returns success" do
            get :index
            expect(response).to be_success
        end
    end
    
    describe "GET#index" do
        it "returns new" do
            get :new
            expect(response).to be_success
        end
    end
    
    describe "POST#create" do
        before{ post :create, :segment => {:name => "test"}}
        it "redirects" do
            expect(response).to redirect_to action: :index
        end
        
        it "creates segment" do
            last_segment = Segment.last
            expect(last_segment.name).to eq("test")
        end
        
        it "flashes" do
            expect(flash[:notice])
        end
    end
    
    describe "GET#show" do
        it "returns success" do
            get :show, :id => segment.id
            expect(response).to be_success
        end
    end
    
    describe "GET#edit" do
        it "returns success" do
            get :edit, :id => segment.id
            expect(response).to be_success
        end
    end
    
    describe "PATCH#update" do
        before{ patch :update, :id => segment.id, :segment => {:name => "updated"}}
        it "redirects" do
            expect(response).to redirect_to(segment)
        end
        
        it "creates segment" do
            segment.reload
            expect(segment.name).to eq("updated")
        end
        
        it "flashes" do
            expect(flash[:notice])
        end
    end
    
    describe "DELETE#destroy" do
        it "returns success" do
            delete :destroy, :id => segment.id
            expect(response).to redirect_to action: :index
        end
    end
    
    describe "GET#export_csv" do
        it "returns success" do
            get :export_csv, :id => segment.id
            expect(response).to be_success
        end
    end
end
