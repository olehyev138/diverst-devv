require 'rails_helper'

RSpec.describe PolicyGroupsController, type: :controller do
    let(:enterprise) {create :enterprise}
    let(:user) { create :user, enterprise: enterprise}
    let!(:policy_group) { create :policy_group, enterprise: enterprise }

    describe 'GET #index' do
        context 'with logged user' do
            login_user_from_let

            before { get :index }

            it 'return success' do
                expect(response).to be_success
            end
        end
    end

    describe 'GET #new' do
        context 'with logged user' do
            login_user_from_let

            before { get :new }

            it 'return success' do
                expect(response).to be_success
            end
        end
    end

    describe 'POST #create' do
        context 'with logged user' do
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

            it 'flashes' do
                expect(flash[:notice])
            end
        end
    end

    describe 'PATCH #update' do
        context 'with logged user' do
            login_user_from_let

            before { patch :update, :id => policy_group.id, :policy_group => {:name => "updated"}}

            it 'redirect_to' do
                expect(response).to redirect_to action: :index
            end

            it 'updates the policy_group' do
                policy_group.reload
                expect(policy_group.name).to eq("updated")
            end

            it 'flashes' do
                expect(flash[:notice])
            end
        end
    end

    describe 'DELETE #destroy' do
        context 'with logged user' do
            login_user_from_let

            before { delete :destroy, :id => policy_group.id}

            it 'redirect_to' do
                expect(response).to redirect_to action: :index
            end
        end
    end
end
