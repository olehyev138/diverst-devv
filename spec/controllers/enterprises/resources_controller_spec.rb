require 'rails_helper'

RSpec.describe Enterprises::ResourcesController, type: :controller do
    let(:enterprise){ create(:enterprise, cdo_name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let!(:admin_resource){ create(:resource, title: "title", container: enterprise, file: fixture_file_upload('files/test.csv', 'text/csv'), resource_type: "admin") }
    let!(:national_resource){ create(:resource, title: "title", container: enterprise, file: fixture_file_upload('files/test.csv', 'text/csv'), resource_type: "national") }

    login_user_from_let

    describe "GET#index" do
        before {get :index, enterprise_id: enterprise.id}

        it "returns success" do
            expect(response).to be_success
        end

        it "assigns the admin_resources" do
            expect(assigns[:admin_resources]).to eq([admin_resource])
        end

        it "assigns the national_resources" do
            expect(assigns[:national_resources]).to eq([national_resource])
        end
    end

    describe "GET#new" do
        before {get :new, enterprise_id: enterprise.id, resource_type: "admin"}

        it "returns success" do
            expect(response).to be_success
        end

        it "assigns new resource" do
            expect(assigns[:resource]).to be_a_new(Resource)
        end

        it "sets resource_type" do
            expect(assigns[:resource].resource_type).to eq("admin")
        end
    end

    describe "GET#edit" do
        it "returns success" do
            get :edit, :id => admin_resource.id, enterprise_id: enterprise.id
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
                expect(Resource.count).to eq(2)
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
                expect(Resource.count).to eq(3)
            end
        end
    end

    describe "GET#show" do
        it "returns success" do
            get :show, :id => admin_resource.id, enterprise_id: enterprise.id
            expect(response).to be_success
        end
    end

    describe "PATCH#update" do
        context "invalid params" do
            before {patch :update, enterprise_id: enterprise.id, id: admin_resource.id, resource: {title: nil, file: nil}}

            it "returns edit" do
                expect(response).to render_template(:edit)
            end

            it "doesn't update the resouce" do
                admin_resource.reload
                expect(admin_resource.title).to_not be(nil)
            end
        end

        context "valid params" do
            before :each do
                file = fixture_file_upload('files/test.csv', 'text/csv')
                patch :update, enterprise_id: enterprise.id, id: admin_resource.id, resource: {title: "updated", file: file}
            end

            it "redirect_to index" do
                expect(response).to redirect_to action: :index
            end

            it "updates the resouce" do
                admin_resource.reload
                expect(admin_resource.title).to eq("updated")
            end
        end
    end

    describe "DELETE#destroy" do
        before {delete :destroy, :id => admin_resource.id, enterprise_id: enterprise.id}

        it "returns success" do
            expect(response).to redirect_to action: :index
        end

        it "deletes the resources" do
            expect(Resource.where(:id => admin_resource.id).count).to eq(0)
        end
    end
end
