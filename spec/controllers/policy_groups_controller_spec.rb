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
                expect(assigns[:policy_groups]).to eq [policy_group]
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
        describe 'with logged user' do
            context "with correct params" do
                login_user_from_let


                it 'redirect_to' do
                    post :create, :policy_group => {:name => "name"}
                    expect(response).to redirect_to action: :index
                end

                it 'changes the policy_group count' do
                    expect{post :create, :policy_group => {:name => "name"}}
                    .to change(PolicyGroup, :count).by(1)
                end

                it 'flashes a notice message' do
                    post :create, :policy_group => {:name => "name"}
                    expect(flash[:notice]).to eq "Your policy group was created"
                end
            end

            context "with incorrect params" do
                login_user_from_let

                it 'does not create a policy_group object' do
                    expect{post :create, :policy_group => { :name => nil }}
                    .to change(PolicyGroup, :count).by(0)
                end

                it "flashes an alert message" do
                    post :create, :policy_group => { :name => nil }
                    expect(flash[:alert]).to eq "Your policy group was not created. Please fix the errors"
                end

                it "render new template" do
                    post :create, :policy_group => { :name => nil }
                    expect(response).to render_template :new
                end
            end
        end

        describe "without a logged in user" do
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

            context "when adding users" do

                login_user_from_let

                before do
                    user_1 = create(:user, :enterprise => enterprise)
                    user_2 = create(:user, :enterprise => enterprise)
                    patch :update, :id => policy_group.id, :policy_group => {:name => "updated", :new_users => ["", user_1.id, user_2.id]}, :commit => "Add User(s)"
                end

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

                it 'adds the users' do
                    policy_group.reload
                    expect(policy_group.users.length).to eq(2)
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

            context 'before hook to ensure other policy_group is set as default before policy_group object is destroyed' do
                let!(:policy_group1) { create(:policy_group, enterprise: enterprise) }

                it "destroys policy_group object" do
                    expect{delete :destroy, :id => policy_group.id}.to change(PolicyGroup, :count).by(-1)
                end
            end
        end

        context "without a logged in user" do
           before { delete :destroy, :id => policy_group.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
end
