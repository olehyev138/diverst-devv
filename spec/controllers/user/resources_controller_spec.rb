require 'rails_helper'

RSpec.describe User::ResourcesController, type: :controller do
    let(:enterprise){ create(:enterprise, cdo_name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:resource){ create(:resource, container: enterprise, file: fixture_file_upload('files/test.csv', 'text/csv')) }
    
    login_user_from_let
    
    describe "GET#index" do
        it "returns success" do
            get :index, enterprise_id: enterprise.id
            expect(response).to be_success
        end
    end
    
    describe "GET#new" do
        it "returns success" do
            get :new, enterprise_id: enterprise.id
            expect(response).to be_success
        end
    end
    
    describe "GET#edit" do
        it "returns success" do
            get :edit, :id => resource.id, enterprise_id: enterprise.id
            expect(response).to be_success
        end
    end
    
    describe "POST#create" do
        context "invalid params" do
            before {post :create, enterprise_id: enterprise.id, resource: {title: "resource"}}
            
            it "returns edit" do
                expect(response).to render_template(:edit)
            end
            
            it "doesn't create the resource" do
                expect(Resource.count).to eq(0)
            end
        end
        
        context "valid params" do
            before :each do
                file = fixture_file_upload('files/test.csv', 'text/csv')
                post :create, enterprise_id: enterprise.id, resource: {title: "resource", file: file}
            end
            
            it "redirect_to index" do
                expect(response).to redirect_to action: :index
            end
            
            it "creates the resouce" do
                expect(Resource.count).to eq(1)
            end
        end
    end
    
    describe "GET#show" do
        it "returns success" do
            get :show, :id => resource.id, enterprise_id: enterprise.id
            expect(response).to be_success
        end
    end
    
    describe "PATCH#update" do
        context "invalid params" do
            before {patch :update, enterprise_id: enterprise.id, id: resource.id, resource: {title: nil, file: nil}}
            
            it "returns edit" do
                expect(response).to render_template(:edit)
            end
            
            it "doesn't update the resouce" do
                resource.reload
                expect(resource.title).to_not be(nil)
            end
        end
        
        context "valid params" do
            before :each do
                file = fixture_file_upload('files/test.csv', 'text/csv')
                patch :update, enterprise_id: enterprise.id, id: resource.id, resource: {title: "updated", file: file}
            end
            
            it "redirect_to index" do
                expect(response).to redirect_to action: :index
            end
            
            it "updates the resouce" do
                resource.reload
                expect(resource.title).to eq("updated")
            end
        end
    end
    
    describe "DELETE#destroy" do
        before {delete :destroy, :id => resource.id, enterprise_id: enterprise.id}
        
        it "returns success" do
            expect(response).to redirect_to action: :index
        end
        
        it "deletes the resources" do
            expect(Resource.where(:id => resource.id).count).to eq(0)
        end
    end
end
