require 'rails_helper'

RSpec.describe ExpensesController, type: :controller do
    let(:enterprise){ create(:enterprise, cdo_name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:category){create(:expense_category)}
    let(:expense){create(:expense, enterprise: enterprise)}
    let(:expense_category_1) {create(:expense_category, expense: expense)}
    
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
                let(:expense) { FactoryGirl.attributes_for(:expense, :category_id => category.id )}
            
                it 'redirects to correct action' do
                    post :create, expense: expense
                    expect(response).to redirect_to action: :index
                end

                it 'creates new expense' do
                    expect{
                    post :create, expense: expense
                    }.to change(Expense,:count).by(1)
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
                get :edit, :id => expense.id
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
                before(:each){ patch :update, id: expense.id, expense: attributes_for(:expense, name: "updated") }

                it "updates the expense" do
                    expense.reload
                    expect(expense.name).to eq "updated"
                end

                it "redirects to action index" do
                    expect(response).to redirect_to action: :index
                end

                it "flashes notice" do
                    expect(flash[:notice])
                end
            end

            context "with invalid parameters" do
                before(:each){ patch :update, id: expense.id, expense: attributes_for(:expense, name: "") }

                it "does not update the expense" do
                    expense.reload
                    expect(expense.name).to_not eq ""
                end

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

            it "destroy the expense" do
                delete :destroy, id: expense.id
                expect(response).to redirect_to action: :index
            end
        end
    end
end
