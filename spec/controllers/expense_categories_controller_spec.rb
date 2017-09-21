require 'rails_helper'

RSpec.describe ExpenseCategoriesController, type: :controller do
    let(:enterprise){ create(:enterprise, cdo_name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:group){ create(:group, enterprise: enterprise) }
    let(:expense_category){create(:expense_category, enterprise: enterprise)}
    
    describe "GET#index" do
        describe "with logged in user" do
            login_user_from_let
            
            it "returns success" do
                get :index
                expect(response).to be_success
            end
        end
    end
    
    describe "GET#new" do
        describe "with logged in user" do
            login_user_from_let
            
            it "returns success" do
                get :new
                expect(response).to be_success
            end
        end
    end
    
    describe "POST#create" do
        describe "with logged in user" do
            login_user_from_let
            
            context 'with correct params' do
                let(:expense_category) { FactoryGirl.attributes_for(:expense_category) }
            
                it 'redirects to correct action' do
                    post :create, expense_category: expense_category
                    expect(response).to redirect_to action: :index
                end
            
                it 'creates new expense_category' do
                    expect{
                    post :create, expense_category: expense_category
                    }.to change(ExpenseCategory,:count).by(1)
                end
                
                it "flashes" do
                    expect(flash[:notice])
                end
            end
        end
    end
    
    describe "GET#edit" do
        describe "with logged in user" do
            login_user_from_let
            
            it "returns success" do
                get :edit, :id => expense_category.id
                expect(response).to be_success
            end
        end
    end
    
    describe "PATCH#update" do
        describe "with logged in user" do
            before :each do 
                request.env["HTTP_REFERER"] = "back"
            end
            login_user_from_let
            
            context "with valid parameters" do
                before(:each){ patch :update, id: expense_category.id, expense_category: {name: "updated"} }
                
                it "updates the expense_category" do
                    expense_category.reload
                    expect(expense_category.name).to eq "updated"
                end
                
                it "redirects to action index" do
                    expect(response).to redirect_to action: :index
                end
                
                it "flashes notice" do 
                    expect(flash[:notice])
                end
            end
            
            context "with invalid parameters" do
                before(:each){ patch :update, id: expense_category.id, expense_category: {name: nil} }
                
                it "renders action edit" do
                    expect(response).to render_template :edit
                end
                
                it "flashes alert" do
                    expect(flash[:alert])
                end
            end
        end
    end
    
    describe "DELETE#destroy" do
        describe "with logged in user" do

            login_user_from_let
            
            it "destroy the expense_category" do
                delete :destroy, id: expense_category.id
                expect(response).to redirect_to action: :index
            end
        end
    end
end
