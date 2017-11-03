require 'rails_helper'

RSpec.describe Groups::ResourcesController, type: :controller do
    let(:enterprise){ create(:enterprise, cdo_name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let!(:admin_resource){ create(:resource, title: "title", container: enterprise, file: fixture_file_upload('files/test.csv', 'text/csv'), resource_type: "admin") }
    let!(:national_resource){ create(:resource, title: "title", container: enterprise, file: fixture_file_upload('files/test.csv', 'text/csv'), resource_type: "national") }
    let(:group){ create(:group, enterprise: user.enterprise) }
    let(:user_group){ create(:user_group, group: group, user: user) }
    let!(:group_resource){ create(:resource, title: "title", container: group, file: fixture_file_upload('files/test.csv', 'text/csv')) }
    
    login_user_from_let
    
    describe "GET#index" do
        before {get :index, group_id: group.id}
        
        it "returns success" do
            expect(response).to be_success
        end
        
        it "assigns the group_resources" do
            expect(assigns[:group_resources]).to eq([group_resource])
        end
        
        it "assigns the national_resources" do
            expect(assigns[:national_resources]).to eq([national_resource])
        end
    end
    
    describe "GET#new" do
        before {get :new, group_id: group.id}
        
        it "returns success" do
            expect(response).to be_success
        end
        
        it "assigns new resource" do
            expect(assigns[:resource]).to be_a_new(Resource)
        end
    end
    
    describe "GET#edit" do
        it "returns success" do
            get :edit, :id => group_resource.id, group_id: group.id
            expect(response).to be_success
        end
    end
    
    describe "POST#create" do
        context "invalid params" do
            before {post :create, group_id: group.id, resource: {title: "resource"}}
            
            it "returns edit" do
                expect(response).to render_template(:edit)
            end
            
            it "doesn't create the resource" do
                expect(Resource.count).to eq(3)
            end
        end
        
        context "valid params" do
            before :each do
                file = fixture_file_upload('files/test.csv', 'text/csv')
                post :create, group_id: group.id, resource: {title: "resource", file: file}
            end
            
            it "redirect_to index" do
                expect(response).to redirect_to action: :index
            end
            
            it "creates the resouce" do
                expect(Resource.count).to eq(4)
            end
        end
    end
    
    describe "GET#show" do
        it "returns success" do
            get :show, :id => group_resource.id, group_id: group.id
            expect(response).to be_success
        end
    end
    
    describe "PATCH#update" do
        context "invalid params" do
            before {patch :update, group_id: group.id, id: group_resource.id, resource: {title: nil, file: nil}}
            
            it "returns edit" do
                expect(response).to render_template(:edit)
            end
            
            it "doesn't update the resouce" do
                group_resource.reload
                expect(group_resource.title).to_not be(nil)
            end
        end
        
        context "valid params" do
            before :each do
                file = fixture_file_upload('files/test.csv', 'text/csv')
                patch :update, group_id: group.id, id: group_resource.id, resource: {title: "updated", file: file}
            end
            
            it "redirect_to index" do
                expect(response).to redirect_to action: :index
            end
            
            it "updates the resouce" do
                group_resource.reload
                expect(group_resource.title).to eq("updated")
            end
        end
    end
    
    describe "DELETE#destroy" do
        before {delete :destroy, :id => group_resource.id, group_id: group.id}
        
        it "returns success" do
            expect(response).to redirect_to action: :index
        end
        
        it "deletes the resource" do
            expect(Resource.where(:id => group_resource.id).count).to eq(0)
        end
    end
end
