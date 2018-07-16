require 'rails_helper'

RSpec.describe Groups::ResourcesController, type: :controller do
    let(:enterprise){ create(:enterprise, name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let!(:admin_resource){ create(:resource, title: "title", enterprise: enterprise, file: fixture_file_upload('files/test.csv', 'text/csv'), resource_type: "admin") }
    let!(:national_resource){ create(:resource, title: "title", enterprise: enterprise, file: fixture_file_upload('files/test.csv', 'text/csv'), resource_type: "national") }
    let(:group){ create(:group, enterprise: user.enterprise) }
    let(:user_group){ create(:user_group, group: group, user: user) }

    describe "GET#index" do
        describe 'with user logged in' do
            login_user_from_let

            context 'if erg_leader_permissions applies to group object' do
                let!(:group_leader) { create(:group_leader, user: user, group: group) }
                let!(:group_resource) { create(:resource, title: "title", group: group, file: fixture_file_upload('files/test.csv', 'text/csv')) }
                before {get :index, group_id: group.id}

                it "assigns the group_resources" do
                    expect(assigns[:group_resources]).to eq([group_resource])
                end

                it "assigns the national_resources" do
                    expect(assigns[:national_resources]).to eq([national_resource])
                end

                it 'renders index template' do 
                    expect(response).to render_template :index
                end
            end

            context 'if erg_leader_permissions does not apply to group object' do
                before {get :index, group_id: group.id}

                it "assigns the group_resources with an empty array" do
                    expect(assigns[:group_resources]).to eq []
                end

                it "assigns the national_resources" do
                    expect(assigns[:national_resources]).to eq([national_resource])
                end

                 it 'renders index template' do 
                    expect(response).to render_template :index
                end
            end
        end

        describe "with a user not logged in" do
            before {get :index, group_id: group.id}
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#new" do
        describe 'with logged in user' do
            login_user_from_let
            before {get :new, group_id: group.id}

            it "render new template" do
                expect(response).to render_template :new
            end

            it "assigns new resource" do
                expect(assigns[:resource]).to be_a_new(Resource)
            end
        end

        describe "with a user not logged in" do
            before {get :new, group_id: group.id}
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#edit" do
        describe 'with user logged in' do 
            login_user_from_let
            let!(:group_resource) { create(:resource, title: "title", group: group, file: fixture_file_upload('files/test.csv', 'text/csv')) }
            before { get :edit, :id => group_resource.id, group_id: group.id }

            it 'assigns a valid resource object' do
                expect(assigns[:resource]).to be_valid
            end

            it "render edit template" do
                expect(response).to render_template :edit
            end
        end

        describe "with a user not logged in" do
            let!(:group_resource) { create(:resource, title: "title", group: group, file: fixture_file_upload('files/test.csv', 'text/csv')) }
            before { get :edit, :id => group_resource.id, group_id: group.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "POST#create" do
        describe 'when user is logged in' do
            login_user_from_let
            let!(:file)  { fixture_file_upload('files/test.csv', 'text/csv') }

            context "valid params" do
                it "redirect_to index" do
                    post :create, group_id: group.id, resource: {title: "resource", file: file}
                    expect(response).to redirect_to action: :index
                end

                it "creates the resouce" do
                    expect{post :create, group_id: group.id, resource: {title: "resource", file: file}}
                    .to change(Resource, :count).by(1)
                end
            end

            context "invalid params" do
                before {post :create, group_id: group.id, resource: {title: "resource"}}

                it "returns edit" do
                    expect(response).to render_template(:edit)
                end

                it "doesn't create the resource" do
                    expect(Resource.count).to eq(2)
                end
            end
        end

        describe "with a user not logged in" do
            let!(:file)  { fixture_file_upload('files/test.csv', 'text/csv') }
            before { post :create, group_id: group.id, resource: {title: "resource", file: file} }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#show" do
        describe 'with user logged in' do
            login_user_from_let
            let!(:group_resource) { create(:resource, title: "title", group: group, file: fixture_file_upload('files/test.csv', 'text/csv')) }
            before { get :show, :id => group_resource.id, group_id: group.id }


            it 'returns a valid resource object' do 
                expect(assigns[:resource]).to be_valid
            end

            it "filename should be test.csv" do
                expect(response.headers["Content-Disposition"]).to include "test.csv"
            end

            it 'returns format in csv' do 
                expect(response.content_type).to eq 'text/csv'
            end
        end

        describe 'with user not logged in' do
            let!(:group_resource) { create(:resource, title: "title", group: group, file: fixture_file_upload('files/test.csv', 'text/csv')) }
            before { get :show, :id => group_resource.id, group_id: group.id  }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "PATCH#update" do
        let!(:file) { fixture_file_upload('files/test.csv', 'text/csv') }

        describe 'with logged in user' do
            login_user_from_let
            let!(:group_resource) { create(:resource, title: "title", group: group, file: fixture_file_upload('files/test.csv', 'text/csv')) }

            context "valid params" do
                before do
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
        end

        describe 'with user not logged in' do
            let!(:group_resource) { create(:resource, title: "title", group: group, file: fixture_file_upload('files/test.csv', 'text/csv')) }
            before { patch :update, group_id: group.id, id: group_resource.id, resource: {title: "updated", file: file} }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "DELETE#destroy" do
        let!(:group_resource) { create(:resource, title: "title", group: group, file: fixture_file_upload('files/test.csv', 'text/csv')) }

        context 'with logged in user' do
            login_user_from_let

            it "redirects to action index" do
                delete :destroy, :id => group_resource.id, group_id: group.id
                expect(response).to redirect_to action: :index
            end

            it "deletes the resource" do
                expect{delete :destroy, :id => group_resource.id, group_id: group.id}.to change(Resource.where(:id => group_resource.id), :count).by(-1)
            end
        end

        context 'with user not logged in' do 
            before { delete :destroy, :id => group_resource.id, group_id: group.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
end
