require 'rails_helper'

RSpec.describe User::ResourcesController, type: :controller do
    let!(:enterprise) { create(:enterprise, name: "test") }
    let!(:user) { create(:user, enterprise: enterprise) }
    let!(:resource) { create(:resource, enterprise: enterprise, file: fixture_file_upload('files/test.csv', 'text/csv')) }

    describe "GET#index" do
        context "when user is logged in" do
            login_user_from_let
            before { get :index, enterprise_id: enterprise.id }

            it "render index template" do
                expect(response).to render_template :index
            end


            it "returns resources belonging to enterprise" do
                expect(assigns[:container].resources).to eq [resource]
            end
        end

        context "when user is not logged in" do
            before { get :index, enterprise_id: enterprise.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#new" do
        describe "when user is logged in" do
            login_user_from_let
            before { get :new, enterprise_id: enterprise.id }

            it "sets container with enterprise" do
                expect(assigns[:container]).to eq enterprise
            end

            it "returns a new resource" do
                expect(assigns[:resource]).to be_a_new(Resource)
            end

            it "render new template" do
                expect(response).to render_template :new
            end
        end

        context "when user is not logged in" do
            before { get :new, enterprise_id: enterprise.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#edit" do
        describe "when user is logged in" do
            login_user_from_let
            before { get :edit, :id => resource.id, enterprise_id: enterprise.id }

            it "sets container with enterprise" do
                expect(assigns[:container]).to eq enterprise
            end

            it "returns success" do
                expect(response).to render_template :edit
            end
        end

        context "when user is not logged in" do
            before { get :edit, :id => resource.id, enterprise_id: enterprise.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "POST#create" do
        describe "when user is logged in" do
            login_user_from_let
            let!(:test_file) { fixture_file_upload('files/test.csv', 'text/csv') }

            context "valid params" do
                it "redirect_to index" do
                    post :create, enterprise_id: enterprise.id, resource: {title: "resource", file: test_file}
                    expect(response).to redirect_to action: :index
                end

                it "creates the resource" do
                    expect{post :create, enterprise_id: enterprise.id, resource: {title: "resource", file: test_file}}
                    .to change(Resource, :count).by(1)
                end
            end

            context "invalid params" do
                before { post :create, enterprise_id: enterprise.id, resource: {title: nil}}

                it "returns edit" do
                    expect(response).to render_template(:edit)
                end

                it "doesn't create the resource" do
                    expect{post :create, enterprise_id: enterprise.id, resource: {title: nil}}
                    .to change(Resource, :count).by(0)
                end
            end
        end

        describe "when user is not logged in" do
            let!(:test_file) { fixture_file_upload('files/test.csv', 'text/csv') }
            before { post :create, enterprise_id: enterprise.id, resource: {title: "resource", file: test_file} }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#show" do
        describe "when user is logged in" do
            login_user_from_let
            before { get :show, :id => resource.id, enterprise_id: enterprise.id }

            it "response should contain csv" do
              expect(response.content_type).to eq "text/csv"
            end

            it "filename should be test.csv" do
                expect(response.headers["Content-Disposition"]).to include "test.csv"
            end
        end

         describe "when user is not logged in" do
            before { get :show, :id => resource.id, enterprise_id: enterprise.id }
            it_behaves_like "redirect user to users/sign_in path"
         end
    end

    describe "PATCH#update" do
        describe "when user is logged in" do
            login_user_from_let
            let!(:test_file) { fixture_file_upload('files/test.csv', 'text/csv') }

            context "valid params" do
                before do
                    file = fixture_file_upload('files/test.csv', 'text/csv')
                    patch :update, enterprise_id: enterprise.id, id: resource.id, resource: {title: "updated", file: test_file}
                end

                it "redirect_to index" do
                    expect(response).to redirect_to action: :index
                end

                it "updates the resouce" do
                    resource.reload
                    expect(resource.title).to eq("updated")
                end
            end

            context "invalid params" do
                before {patch :update, enterprise_id: enterprise.id, id: resource.id, resource: {title: nil, file: nil}}

                it "returns edit" do
                    expect(response).to render_template(:edit)
                end

                it "doesn't update the resource" do
                    resource.reload
                    expect(resource.title).to_not be(nil)
                end
            end
        end

        describe "when user is not logged in" do
            let!(:test_file) { fixture_file_upload('files/test.csv', 'text/csv') }
            before { patch :update, enterprise_id: enterprise.id, id: resource.id, resource: {title: "updated", file: test_file} }
            it_behaves_like "redirect user to users/sign_in path"
         end
    end

    describe "DELETE#destroy" do
        describe "when user is logged in" do
            login_user_from_let
             before { delete :destroy, :id => resource.id, enterprise_id: enterprise.id }

            it "returns success" do
                expect(response).to redirect_to action: :index
            end

            it "deletes the resources" do
                expect(Resource.where(:id => resource.id).count).to eq(0)
            end
        end

        describe "when user is not logged in" do
            before { delete :destroy, :id => resource.id, enterprise_id: enterprise.id }
            it_behaves_like "redirect user to users/sign_in path"
         end
    end
end
