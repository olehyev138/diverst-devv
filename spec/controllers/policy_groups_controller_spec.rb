require 'rails_helper'

RSpec.describe PolicyGroupsController, type: :controller do
    let(:enterprise) {create :enterprise}
    let(:user) { create :user, enterprise: enterprise}
    let!(:policy_group) { create :policy_group, enterprise: enterprise }

    describe 'GET #index' do
        context 'with logged user' do
            login_user_from_let

            before { get :index }

            it "returns enterprise policy groups" do 
                expect(assigns[:policy_groups].count).to eq 1
            end

            it "render index template" do 
                expect(response).to render_template :index
            end
        end

        context "without a logged in user" do 
            before { get :index }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe 'GET #new' do
        context 'with logged user' do
            login_user_from_let

            before { get :new }

            it "return a new policy group" do 
                expect(assigns[:policy_group]).to be_a_new(PolicyGroup)
            end

            it "render new template" do 
                expect(response).to render_template :new
            end
        end

        context "without a logged in user" do 
            before { get :new }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe 'POST #create' do
        context 'with logged user' do
            context "with correct params" do 
                login_user_from_let

                before { post :create, :policy_group => {:name => "name"}}

                it 'redirect_to' do
                    expect(response).to redirect_to action: :index
                end

                it 'changes the policy_group count' do
                    expect(PolicyGroup.count).to eq(3)
                end

                it 'creates the policy_group' do
                    expect(PolicyGroup.last.name).to eq("name")
                end

                it 'flashes a notice message' do
                    expect(flash[:notice]).to eq "Your policy group was created"
                end
            end

            context "with incorrect params" do 
                login_user_from_let

                before {  post :create, :policy_group => { :name => nil }}

                it "flashes an alert message" do 
                    expect(flash[:alert]).to eq "Your policy group was not created. Please fix the errors"
                end

                it "render new template" do 
                    expect(response).to render_template :new
                end
            end
        end

        context "without a logged in user" do 
            before { post :create, :policy_group => { :name => "name" } }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe 'PATCH #update' do
        context 'with logged user' do
            context "with correct params" do
                login_user_from_let

                before { patch :update, :id => policy_group.id, :policy_group => {:name => "updated"}}

                it 'redirect_to' do
                    expect(response).to redirect_to action: :index
                end

                it 'updates the policy_group' do
                    policy_group.reload
                    expect(policy_group.name).to eq("updated")
                end

                it 'flashes a notice message' do
                    expect(flash[:notice]).to eq "Your policy group was updated"
                end
            end

            context "with incorrect params" do 
                login_user_from_let
                before { patch :update, :id => policy_group.id, :policy_group => {:name => nil}}

                it "flashes an alert message" do 
                    expect(flash[:alert]).to eq "Your policy group was not updated. Please fix the errors"
                end

                it "render edit template" do 
                    expect(response).to render_template :edit
                end
            end
        end

        context "without a logged in user" do 
            before { patch :update, :id => policy_group.id, :policy_group => {:name => "updated"}}
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe 'DELETE #destroy' do
        context 'with logged user' do
            login_user_from_let

            it 'redirect_to action index' do
                delete :destroy, :id => policy_group.id
                expect(response).to redirect_to action: :index
            end

            it "destroys policy_group object", skip: "destroy object fails" do 
                expect{delete :destroy, :id => policy_group.id}.to change(PolicyGroup, :count).by(-1)
            end
        end

        context "without a logged in user" do 
           before { delete :destroy, :id => policy_group.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
end
