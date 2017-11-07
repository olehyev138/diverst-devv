require 'rails_helper'

RSpec.describe Groups::FoldersController, type: :controller do
    let(:enterprise){ create(:enterprise, cdo_name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:group){ create(:group, enterprise: user.enterprise) }
    let(:user_group){ create(:user_group, group: group, user: user) }
    let!(:folder){ create(:folder, :container => group) }

    login_user_from_let
    
    describe "GET#index" do
        before {get :index, group_id: group.id}
        
        it "returns success" do
            expect(response).to be_success
        end
        
        it "assigns the folders" do
            expect(assigns[:folders]).to eq([folder])
        end
    end
    
    describe "GET#new" do
        before {get :new, group_id: group.id}
        
        it "returns success" do
            expect(response).to be_success
        end
        
        it "assigns new folder" do
            expect(assigns[:folder]).to be_a_new(Folder)
        end
        
        it "sets container_type" do
            expect(assigns[:folder].container_type).to eq("Group")
        end
    end
    
    describe "GET#edit" do
        it "returns success" do
            get :edit, :id => folder.id, group_id: group.id
            expect(response).to be_success
        end
    end
    
    describe "POST#create" do
        context "invalid params" do
            before {post :create, group_id: group.id, folder: {name: nil}}
            
            it "returns edit" do
                expect(response).to render_template(:edit)
            end
            
            it "doesn't create the folder" do
                expect(Folder.count).to eq(1)
            end
        end
        
        context "valid params" do
            before :each do
                post :create, group_id: group.id, folder: {name: "folder"}
            end
            
            it "redirect_to index" do
                expect(response).to redirect_to action: :index
            end
            
            it "creates the folder" do
                expect(Folder.count).to eq(2)
            end
        end
    end
    
    describe "PATCH#update" do
        context "invalid params" do
            before {patch :update, group_id: group.id, id: folder.id, folder: {name: nil}}
            
            it "returns edit" do
                expect(response).to render_template(:edit)
            end
            
            it "doesn't update the folder" do
                folder.reload
                expect(folder.name).to_not be(nil)
            end
        end
        
        context "valid params" do
            before :each do
                patch :update, group_id: group.id, id: folder.id, folder: {name: "updated"}
            end
            
            it "redirect_to index" do
                expect(response).to redirect_to action: :index
            end
            
            it "updates the folder" do
                folder.reload
                expect(folder.name).to eq("updated")
            end
        end
    end
    
    describe "DELETE#destroy" do
        before {delete :destroy, :id => folder.id, group_id: group.id}
        
        it "returns success" do
            expect(response).to redirect_to action: :index
        end
        
        it "deletes the folder" do
            expect(Folder.where(:id => folder.id).count).to eq(0)
        end
    end
end
