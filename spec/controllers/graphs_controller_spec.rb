require 'rails_helper'

RSpec.describe GraphsController, type: :controller do
    let(:enterprise) { create(:enterprise, cdo_name: "test") }
    let(:user) { create(:user, enterprise: enterprise) }
    let(:metrics_dashboard) { create(:metrics_dashboard, enterprise_id: enterprise.id) }
    let(:poll) { create(:poll, enterprise_id: enterprise.id) }
    let(:field1) { create(:field, type: "NumericField", container: poll) }
    let(:field2) { create(:field, type: "NumericField", container: poll) }
    let(:metrics_graph) { create(:graph, collection: metrics_dashboard, field: field1) }
    let(:poll_graph) { create(:graph, collection: poll, field: field2) }

    describe "GET#new" do
        describe "with logged in user" do
            login_user_from_let
            before { get :new, :metrics_dashboard_id => metrics_dashboard.id }

            it "returns a new graph object" do
                expect(assigns[:graph]).to be_a_new(Graph)
            end

            it "render template" do
                expect(response).to render_template :new
            end
        end

        describe "without a logged in user" do
            before { get :new, :metrics_dashboard_id => metrics_dashboard.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "POST#create" do
        describe "with logged in user" do
            login_user_from_let

            context "with valid field id" do
                it "redirect to @collection" do
                    post :create, :metrics_dashboard_id => metrics_dashboard.id, :graph => {field_id: field1.id}
                    expect(response).to redirect_to metrics_dashboard
                end

                it 'creates new graph' do
                    expect{
                        post :create, :metrics_dashboard_id => metrics_dashboard.id, :graph => { field_id: field1.id } }.to change(Graph, :count).by(1)
                end

                it "flashes a notice message" do
                    post :create, :metrics_dashboard_id => metrics_dashboard.id, :graph => { field_id: field1.id }
                    expect(flash[:notice]).to eq "Your graph was created"
                end
            end

            context "with field id as nil" do
                before { post :create, :metrics_dashboard_id => metrics_dashboard.id, :graph => { field_id: nil } }

                it "flashes an alert message" do
                    expect(flash[:alert]).to eq "Your graph was not created. Please fix the errors"
                end

                it "render a new template" do
                    expect(response).to render_template :new
                end
            end
        end

        describe "without a logged in user" do
            before { post :create, :metrics_dashboard_id => metrics_dashboard.id, :graph => { field_id: field1.id } }

            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "GET#index", :skip => "Missing a template" do
        describe "with logged in user" do
            login_user_from_let

            it "returns success" do
                get :index, :metrics_dashboard_id => metrics_dashboard.id
                expect(response).to be_success
            end
        end
    end


    describe "PATCH#update" do
        describe "with logged in user" do
            login_user_from_let

            context "with valid field id" do
                before { patch :update, :metrics_dashboard_id => metrics_dashboard.id, :id => metrics_graph.id, :graph => { field_id: field1.id } }

                it "redirects to metrics_dashboard" do
                    expect(response).to redirect_to metrics_dashboard
                end

                it 'updates the graph' do
                    metrics_graph.reload
                    expect(metrics_graph.field_id).to eq(field1.id)
                end

                it "flashes a notice message" do
                    expect(flash[:notice]).to eq "Your graph was updated"
                end
            end

            context "with field id as nil" do
                before { patch :update, :metrics_dashboard_id => metrics_dashboard.id, :id => metrics_graph.id, :graph => { field_id: nil } }

                it "render edit template" do
                    expect(response).to render_template :edit
                end

                it "flashes an alert message" do
                    expect(flash[:alert]).to eq "Your graph was not updated. Please fix the errors"
                end
            end
        end

        describe "without logged in user" do
            before { patch :update, :metrics_dashboard_id => metrics_dashboard.id, :id => metrics_graph.id, :graph => { field_id: field1.id } }

            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "DELETE#destroy" do
        describe "with logged in user" do

            login_user_from_let
            subject { delete :destroy, :metrics_dashboard_id => metrics_dashboard.id, :id => metrics_graph.id }
            before {request.env["HTTP_REFERER"] = "back"}

            context "when metrics_graph" do
                it "returns to previous destination" do
                    expect(subject).to redirect_to "back"
                end

                it "destroys a graph object" do
                    metrics_graph
                    expect{ subject }.to change(Graph, :count).by(-1)
                end
            end
        end

        describe "without a logged in user" do
            before { delete :destroy, :metrics_dashboard_id => metrics_dashboard.id, :id => metrics_graph.id }

            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#data" do

        before { User.__elasticsearch__.create_index!(index: User.es_index_name(enterprise: enterprise)) }
        after { User.__elasticsearch__.delete_index!(index: User.es_index_name(enterprise: enterprise)) }

        describe "with logged in user" do
            login_user_from_let

            it "returns json format" do
                get :data, :id => metrics_graph.id, format: :json
                expect(response.content_type).to eq "application/json"
            end

            it "returns metrics graph data" do
                get :data, :id => metrics_graph.id, format: :json
                expect(assigns[:graph]).to eq metrics_graph
            end


            it "returns json format" do
                get :data, :id => poll_graph.id, format: :json
                expect(response.content_type).to eq "application/json"
            end

            it "returns poll graph data" do
                get :data, :id => poll_graph.id, format: :json
                expect(assigns[:graph]).to eq poll_graph
            end
        end

        describe "without a logged in user", skip: 'action needs to be reworked to accept enterprise_token instead of current_user' do
            before { get :data, :id => metrics_graph.id, format: :json }

            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#export_csv" do
        before { User.__elasticsearch__.create_index!(index: User.es_index_name(enterprise: enterprise)) }
        after { User.__elasticsearch__.delete_index!(index: User.es_index_name(enterprise: enterprise)) }

        describe "with logged in user" do
            login_user_from_let

            it "returns response in csv format for metrics_graph" do
                get :export_csv, :id => metrics_graph.id
                expect(response.content_type).to eq "text/csv"
            end

            it "returns response in csv format for poll_graph" do
                get :export_csv, :id => poll_graph.id
                expect(response.content_type).to eq "text/csv"
            end

            it "returns success" do
                get :export_csv, :id => poll_graph.id
                expect(response).to be_success
            end

            it "returns success" do
                get :export_csv, :id => metrics_graph.id
                expect(response).to be_success
            end
        end

        describe "without a logged in user", skip: 'needs to be reworked to accept enterprise token instead of current_user' do
            before { get :export_csv, :id => metrics_graph.id }

            it_behaves_like "redirect user to users/sign_in path"
        end
    end
end
