require 'rails_helper'

RSpec.describe Enterprises::Folder::ResourcesController, type: :controller do
    let(:enterprise){ create(:enterprise) }
    let(:user){ create(:user, enterprise: enterprise) }
    let!(:folder){ create(:folder, :enterprise => enterprise) }
    let!(:resource){ create(:resource, title: "title", folder: folder, file: fixture_file_upload('files/test.csv', 'text/csv')) }

    describe "GET#index" do
        context 'when user is logged in' do
            login_user_from_let
            before {get :index, folder_id: folder.id, enterprise_id: enterprise.id}

            it "render index template" do
                expect(response).to render_template :index
            end

            it "assigns the _resources" do
                expect(assigns[:resources]).to eq([resource])
            end

            it "assigns a valid enterprise object" do
                expect(assigns[:enterprise]).to eq enterprise
                expect(assigns[:enterprise]).to be_valid
            end

            it 'sets container path' do
                expect(assigns[:container_path]).to eq [enterprise, folder]
            end
        end

        context 'when user is not logged in' do
            before { get :index, folder_id: folder.id, enterprise_id: enterprise.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#new" do
        context 'when user is logged in' do
            login_user_from_let
            before {get :new, folder_id: folder.id, enterprise_id: enterprise.id}

            it "render new template" do
                expect(response).to render_template :new
            end

            it "assigns new resource" do
                expect(assigns[:resource]).to be_a_new(Resource)
            end

             it "assigns a new enterprise object" do
                expect(assigns[:enterprise]).to eq enterprise
            end

            it 'sets container path' do
                expect(assigns[:container_path]).to eq [enterprise, folder]
            end
        end

        context 'when user is not logged in' do
            before { get :new, folder_id: folder.id, enterprise_id: enterprise.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#edit" do
        context 'when user is logged in' do
            login_user_from_let
            before { get :edit, :id => resource.id, folder_id: folder.id, enterprise_id: enterprise.id }

            it "render edit template" do
                expect(response).to render_template :edit
            end

            it "assigns a valid enterprise object" do
                expect(assigns[:enterprise]).to eq enterprise
                expect(assigns[:enterprise]).to be_valid
            end

            it 'sets container path' do
                expect(assigns[:container_path]).to eq [enterprise, folder]
            end
        end

        context 'when user is not logged in' do
            before { get :edit, :id => resource.id, folder_id: folder.id, enterprise_id: enterprise.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "POST#create" do
        let!(:file) { fixture_file_upload('files/test.csv', 'text/csv') }

        describe 'when user is logged in' do
            login_user_from_let

            context "valid params" do
                it "redirect_to index" do
                    post :create, enterprise_id: enterprise.id, folder_id: folder.id, resource: {title: "resource", file: file}
                    expect(response).to redirect_to action: :index
                end

                it "creates the resource" do
                    expect{post :create, enterprise_id: enterprise.id, folder_id: folder.id, resource: {title: "resource", file: file}}
                    .to change(Resource, :count).by(1)
                end
            end

            context "invalid params" do
                it "render edit template" do
                    post :create, enterprise_id: enterprise.id, folder_id: folder.id, resource: {title: "resource"}
                    expect(response).to render_template(:edit)
                end

                it "doesn't create the resource" do
                    expect{post :create, enterprise_id: enterprise.id, folder_id: folder.id, resource: {title: "resource"}}
                    .to change(Resource, :count).by(0)
                end
            end
        end
    end

    describe "GET#show" do
        context 'when user is logged in' do
            login_user_from_let
            before { get :show, :id => resource.id, folder_id: folder.id, enterprise_id: enterprise.id }

            it 'returns file in csv format' do
                expect(response.content_type).to eq 'text/csv'
            end

            it "filename should be 'test.csv'" do
                expect(response.headers["Content-Disposition"]).to include 'test.csv'
            end

            it "assigns a valid enterprise object" do
                expect(assigns[:enterprise]).to eq enterprise
                expect(assigns[:enterprise]).to be_valid
            end

            it 'sets container path' do
                expect(assigns[:container_path]).to eq [enterprise, folder]
            end
        end

        context 'when user is not logged in' do
            before { get :show, :id => resource.id, folder_id: folder.id, enterprise_id: enterprise.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "PATCH#update" do
        let!(:file) { fixture_file_upload('files/test.csv', 'text/csv') }

        describe 'when user is logged in' do
            login_user_from_let

            context "valid params" do
                before do
                    patch :update, folder_id: folder.id, id: resource.id, enterprise_id: enterprise.id, resource: {title: "updated", file: file}
                end

                it "redirect_to index" do
                    expect(response).to redirect_to action: :index
                end

                it "updates the resource" do
                    resource.reload
                    expect(resource.title).to eq("updated")
                end
            end

            context "invalid params" do
                before {patch :update, folder_id: folder.id, id: resource.id, enterprise_id: enterprise.id, resource: {title: nil, file: nil}}

                it "render edit template" do
                    expect(response).to render_template(:edit)
                end

                it "doesn't update the resource" do
                    resource.reload
                    expect(resource.title).to_not be(nil)
                end
            end
        end

        describe 'when user is not logged in' do
            before {patch :update, folder_id: folder.id, id: resource.id, enterprise_id: enterprise.id, resource: {title: nil, file: nil}}
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "DELETE#destroy" do
        context 'when user is logged in' do
            login_user_from_let

            it "returns success" do
                delete :destroy, :id => resource.id, enterprise_id: enterprise.id, folder_id: folder.id
                expect(response).to redirect_to action: :index
            end

            it "deletes the resource" do
                expect{delete :destroy, :id => resource.id, enterprise_id: enterprise.id, folder_id: folder.id}
                .to change(Resource, :count).by(-1)
            end
        end

        context 'when user is not logged in' do
            before { delete :destroy, :id => resource.id, enterprise_id: enterprise.id, folder_id: folder.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
end
