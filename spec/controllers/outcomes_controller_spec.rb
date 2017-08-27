require 'rails_helper'

RSpec.describe OutcomesController, type: :controller do
    let(:enterprise) {create :enterprise}
    let(:user) { create :user, enterprise: enterprise}
    let!(:group) { create :group, enterprise: user.enterprise }
    let(:outcome) {create :outcome, group_id: group.id}
    
    describe 'GET #index' do
        def get_index(group_id = -1)
            get :index, group_id: group_id
        end
        
        context 'with logged user' do
            login_user_from_let
            
            before { get_index(group.id) }
            
            it 'return success' do
                expect(response).to be_success
            end
        end
    end
    
    describe 'GET #new', :skip => true do
        def get_new(group_id = -1)
            get :new, group_id: group_id
        end
        
        context 'with logged user' do
            login_user_from_let
            
            before { get_new(group.id) }
            
            it 'return success' do
                expect(response).to be_success
            end
        end
    end
    
    describe 'GET #edit', :skip => true do
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
                expect(Outcome.count).to eq(1)
            end
            
            it 'flashes' do
                expect(flash[:notice])
            end
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
            
            before { delete_destroy(group.id) }
            
            it 'redirects to index' do
                expect(response).to redirect_to action: :index
            end
        end
    end
end