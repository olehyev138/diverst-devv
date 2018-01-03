require 'rails_helper'

RSpec.describe Initiatives::ExpensesController, type: :controller do
    let(:user) { create :user }
    let(:group){ create(:group, enterprise: user.enterprise) }
    let(:initiative){ initiative_of_group(group) }
    let(:initiative_expense){create(:initiative_expense, initiative: initiative)}
    
    login_user_from_let
    
    describe 'GET#index' do
        it "gets the expenses" do
            get :index, group_id: group.id, initiative_id: initiative.id
            expect(response).to be_success
        end
    end
    
    describe 'GET#new' do
        it "gets a new expense" do
            get :new, group_id: group.id, initiative_id: initiative.id
            expect(response).to be_success
        end
    end
    
    describe 'POST#create' do
        it "creates the expense" do
            post :create, group_id: group.id, initiative_id: initiative.id, initiative_expense: {amount: 10, description: "description"}
            expect(response).to redirect_to action: :index
        end
        
        it "redirects to new" do
            post :create, group_id: group.id, initiative_id: initiative.id, initiative_expense: {amount: nil, description: nil}
            expect(response).to render_template :new
        end
    end
    
    describe 'GET#time_series' do
        it "gets the time_series in json format" do
            get :time_series, group_id: group.id, initiative_id: initiative.id, format: :json
            expect(response).to be_success
        end
        it "gets the time_series in csv format" do
            get :time_series, group_id: group.id, initiative_id: initiative.id, format: :csv
            expect(response).to be_success
        end
    end
    
    describe 'GET#show', :skip => "Missing template" do
        it "show an expense" do
            get :show, group_id: group.id, initiative_id: initiative.id, id: initiative_expense.id
            expect(response).to be_success
        end
    end
    
    describe 'GET#edit' do
        it "edits an expense" do
            get :edit, group_id: group.id, initiative_id: initiative.id, id: initiative_expense.id
            expect(response).to be_success
        end
    end
    
    describe 'PATCH#update' do
        context "when update succeeds" do
            before {patch :update, group_id: group.id, initiative_id: initiative.id, id: initiative_expense.id, initiative_expense: {amount: 1000}}
            
            it "redirects" do
                expect(response).to redirect_to action: :index
            end
            
            it "flashes" do
                expect(flash[:notice]).to eq "Your expense was updated"
            end
            
            it "updates an expense" do
                initiative_expense.reload
                expect(initiative_expense.amount).to eq(1000)
            end
        end
        
        context "when update doesn't succeed" do
            before {patch :update, group_id: group.id, initiative_id: initiative.id, id: initiative_expense.id, initiative_expense: {amount: nil}}
            
            it "redirects" do
                expect(response).to render_template :edit
            end
            
            it "flashes" do
                expect(flash[:alert]).to eq "Your expense was not updated. Please fix the errors"
            end
        end
    end
    
    describe 'DELETE#destroy' do
        before {delete :destroy, group_id: group.id, initiative_id: initiative.id, id: initiative_expense.id, initiative_expense: {amount: 1000}}
        
        it "redirects" do
            expect(response).to redirect_to action: :index
        end
        
        it "updates an expense" do
            expect(InitiativeExpense.where(:id => initiative_expense.id).count).to eq(0)
        end
    end
end