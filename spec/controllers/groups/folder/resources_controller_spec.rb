require 'rails_helper'

RSpec.describe Groups::Folder::ResourcesController, type: :controller do
    let(:enterprise){ create(:enterprise, cdo_name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:group){ create(:group, enterprise: user.enterprise) }
    let(:user_group){ create(:user_group, group: group, user: user) }
    let!(:folder){ create(:folder, :container => group) }
    let!(:resource){ create(:resource, title: "title", container: folder, file: fixture_file_upload('files/test.csv', 'text/csv')) }

    login_user_from_let

    describe "GET#index" do
        before {get :index, folder_id: folder.id, group_id: group.id}

        it "returns success" do
            expect(response).to be_success
        end

        it "assigns the _resources" do
            expect(assigns[:resources]).to eq([resource])
        end
    end

    describe "GET#new" do
        before {get :new, folder_id: folder.id, group_id: group.id}

        it "returns success" do
            expect(response).to be_success
        end

        it "assigns new resource" do
            expect(assigns[:resource]).to be_a_new(Resource)
        end
    end

    describe "GET#edit" do
        it "returns success" do
            get :edit, :id => resource.id, folder_id: folder.id, group_id: group.id
            expect(response).to be_success
        end
    end

    describe "POST#create" do
        context "invalid params" do
            before {post :create, group_id: group.id, folder_id: folder.id, resource: {title: "resource"}}

            it "returns edit" do
                expect(response).to render_template(:edit)
            end

            it "doesn't create the resource" do
                expect(Resource.count).to eq(1)
            end
        end

        context "valid params" do
            before :each do
                file = fixture_file_upload('files/test.csv', 'text/csv')
                post :create, group_id: group.id, folder_id: folder.id, resource: {title: "resource", file: file}
            end

            it "redirect_to index" do
                expect(response).to redirect_to action: :index
            end

            it "creates the resouce" do
                expect(Resource.count).to eq(2)
            end
        end
    end

    describe "GET#show" do
        it "returns success" do
            get :show, :id => resource.id, folder_id: folder.id, group_id: group.id
            expect(response).to be_success
        end
    end

    describe "PATCH#update" do
        context "invalid params" do
            before {patch :update, folder_id: folder.id, id: resource.id, group_id: group.id, resource: {title: nil, file: nil}}

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
                patch :update, folder_id: folder.id, id: resource.id, group_id: group.id, resource: {title: "updated", file: file}
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
        before {delete :destroy, :id => resource.id, group_id: group.id, folder_id: folder.id}

        it "returns success" do
            expect(response).to redirect_to action: :index
        end

        it "deletes the resource" do
            expect(Resource.where(:id => resource.id).count).to eq(0)
        end
    end
end
