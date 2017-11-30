require 'rails_helper'

RSpec.describe OutcomesController, type: :controller do
    include ApplicationHelper

    let!(:enterprise) {create :enterprise}
    let!(:user) { create :user, enterprise: enterprise}
    let!(:group) { create :group, enterprise: user.enterprise }
    let!(:outcome) {create :outcome, group_id: group.id}

    describe 'GET #index' do
        def get_index(group_id = -1)
            get :index, group_id: group_id
        end

        context 'with logged user' do
            login_user_from_let

            before { get_index(group.id) }

            it "render index template" do
                expect(response).to render_template :index
            end
        end

        context "with non-logged in user" do
            before { get_index(group.id) }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe 'GET #new', skip: "missing template" do
        def get_new(group_id = -1)
            get :new, group_id: group_id
        end

        context 'with logged user' do
            login_user_from_let

            before { get_new(group.id) }

            it "returns a new Outcome object" do
                expect(assigns[:outcome]).to be_a_new(Outcome)
            end
        end
    end


    describe 'GET #edit', skip: "missing template" do
        def get_edit(group_id = -1)
            get :edit, group_id: group_id, :id => outcome.id
        end

        context 'with logged user' do
            login_user_from_let

            before { get_edit(group.id) }

            it 'return success' do
                expect(response).to be_success
            end
        end
    end


    describe 'POST #create' do
        def post_create(group_id = -1)
            post :create, group_id: group_id, :outcome => {:name => "created", :group_id => group.id}
        end

        context 'with logged user' do
            login_user_from_let

            before { post_create(group.id) }

            it 'redirects to index' do
                expect(response).to redirect_to action: :index
            end

            it 'creates the outcome' do
                expect(Outcome.count).to eq(2)
            end

            it 'flashes a notice message' do
                expect(flash[:notice]).to eq "Your #{ c_t(:outcome) } was created"
            end
        end

        context "incorrect params", skip: "missing template" do
            login_user_from_let
            before {post :create, group_id: group.id, :outcome => {:name => "", :group_id => group.id}}

            it "flashes an alert message" do
                expect(flash[:alert]).to eq "Your #{ c_t(:outcome) } was not created. Please fix the errors"
            end

            it "render new template" do
                expect(response).to render_template :new
            end
        end

        context "without logged in user" do
            before { post :create, group_id: group.id, :outcome => {:name => "created", :group_id => group.id} }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe 'PATCH #update' do
        def patch_update(group_id = -1)
            patch :update, group_id: group_id, :id => outcome.id, :outcome => {:name => "updated"}
        end

        context 'with logged user' do
            login_user_from_let

            before { patch_update(group.id) }

            it 'redirects to index' do
                expect(response).to redirect_to action: :index
            end

            it 'updates the outcome' do
                outcome.reload
                expect(outcome.name).to eq("updated")
            end

            it 'flashes' do
                expect(flash[:notice])
            end
        end
    end

    describe 'DELETE #destroy' do
        def delete_destroy(group_id = -1)
            delete :destroy, group_id: group_id, :id => outcome.id
        end

        context 'with logged user' do
            login_user_from_let

            it 'redirects to index' do
                delete_destroy(group.id)
                expect(response).to redirect_to action: :index
            end

            it "destroys outcome" do
                expect{ delete_destroy(group.id) }.to change(Outcome, :count).by(-1)
            end
        end
    end
end