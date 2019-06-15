require 'rails_helper'

RSpec.describe Initiatives::ExpensesController, type: :controller do
  let(:user) { create :user }
  let(:group) { create(:group, enterprise: user.enterprise) }
  let(:initiative) { initiative_of_group(group) }
  let(:initiative_expense) { create(:initiative_expense, initiative: initiative) }



  describe 'GET#index' do
    describe 'with user logged in' do
      login_user_from_let
      before do
        annual_budget = create(:annual_budget, group_id: group.id)
        budget = create(:budget, is_approved: true, approver_id: user.id, group_id: group.id, annual_budget_id: annual_budget.id)
        get :index, group_id: group.id, initiative_id: initiative.id
      end

      it 'set valid group object' do
        expect(assigns[:group]).to be_valid
      end

      it 'set valid initiative object' do
        expect(assigns[:initiative]).to be_valid
      end

      it 'gets the expenses' do
        expect(assigns[:expenses]).to eq [initiative_expense]
      end

      it 'renders index template' do
        expect(response).to render_template :index
      end
    end

    describe 'without user logged in' do
      before { get :index, group_id: group.id, initiative_id: initiative.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET#new' do
    describe 'with user logged in' do
      login_user_from_let
      before { get :new, group_id: group.id, initiative_id: initiative.id }

      it 'set valid group object' do
        expect(assigns[:group]).to be_valid
      end

      it 'set initiative object' do
        expect(assigns[:initiative]).to eq initiative
      end

      it 'gets a new expense' do
        expect(assigns[:expense]).to be_a_new(InitiativeExpense)
      end

      it 'render a new template' do
        expect(response).to render_template :new
      end
    end

    describe 'with user not logged in' do
      before { get :new, group_id: group.id, initiative_id: initiative.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'POST#create' do
    login_user_from_let

    context 'with valid attributes' do
      before do
        annual_budget = create(:annual_budget, group_id: group.id)
        budget = create(:budget, is_approved: true, approver_id: user.id, group_id: group.id, annual_budget_id: annual_budget.id)
      end

      it 'creates the initiative_expense object' do
        expect { post :create, group_id: group.id, initiative_id: initiative.id, initiative_expense: { amount: 10, description: 'description' } }
        .to change(InitiativeExpense, :count).by(1)
      end

      it 'flashes a notice message' do
        post :create, group_id: group.id, initiative_id: initiative.id, initiative_expense: { amount: 10, description: 'description' }
        expect(flash[:notice]).to eq 'Your expense was created'
      end

      it 'redirects to action index' do
        post :create, group_id: group.id, initiative_id: initiative.id, initiative_expense: { amount: 10, description: 'description' }
        expect(response).to redirect_to action: :index
      end

      it 'redirects to new' do
        post :create, group_id: group.id, initiative_id: initiative.id, initiative_expense: { amount: nil, description: nil }
        expect(response).to render_template :new
      end
    end

    context 'when user attempts to create an expense with no budget approval' do
      it 'does not create the initiative expense object' do
        expect { post :create, group_id: group.id, initiative_id: initiative.id, initiative_expense: { amount: 10, description: 'description' } }
        .to change(InitiativeExpense, :count).by(0)
      end

      it 'displays a flash alert' do
        post :create, group_id: group.id, initiative_id: initiative.id, initiative_expense: { amount: 10, description: 'description' }
        expect(flash[:alert]).to eq 'you can not create any expense with no budget approval'
      end

      it 'renders new template' do
        post :create, group_id: group.id, initiative_id: initiative.id, initiative_expense: { amount: 10, description: 'description' }
        expect(response).to render_template(:new)
      end
    end

    context 'with invalid attributes' do
      before do
        annual_budget = create(:annual_budget, group_id: group.id)
        budget = create(:budget, is_approved: true, approver_id: user.id, group_id: group.id, annual_budget_id: annual_budget.id)
      end

      it 'does not create initiative_expense object' do
        expect { post :create, group_id: group.id, initiative_id: initiative.id, initiative_expense: { amount: nil, description: 'description' } }
        .to change(InitiativeExpense, :count).by(0)
      end

      it 'flashes an alert message' do
        post :create, group_id: group.id, initiative_id: initiative.id, initiative_expense: { amount: nil, description: 'description' }
        expect(flash[:alert]).to eq 'Your expense was not created. Please fix the errors'
      end

      it 'renders new template' do
        post :create, group_id: group.id, initiative_id: initiative.id, initiative_expense: { amount: nil, description: 'description' }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET#time_series' do
    context 'with user logged in' do
      login_user_from_let

      context 'json' do
        before {
          get :time_series, group_id: group.id, initiative_id: initiative.id, format: :json
        }

        it 'gets the time_series in json format' do
          expect(response.content_type).to eq 'application/json'
        end
      end

      context 'csv' do
        before {
          allow(InitiativeExpensesTimeSeriesDownloadJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = 'back'
          get :time_series, group_id: group.id, initiative_id: initiative.id, format: :csv
        }

        it 'returns to previous page' do
          expect(response).to redirect_to 'back'
        end

        it 'flashes' do
          expect(flash[:notice]).to eq 'Please check your Secure Downloads section in a couple of minutes'
        end

        it 'calls job' do
          expect(InitiativeExpensesTimeSeriesDownloadJob).to have_received(:perform_later)
        end
      end
    end

    context 'with user not logged in' do
      context 'gets the time_series in json format' do
        before { get :time_series, group_id: group.id, initiative_id: initiative.id, format: :json }
        it_behaves_like 'redirect user to users/sign_in path'
      end

      context 'the time_series in csv format' do
        before { get :time_series, group_id: group.id, initiative_id: initiative.id, format: :csv }
        it_behaves_like 'redirect user to users/sign_in path'
      end
    end
  end


  describe 'GET#edit' do
    context 'with user logged in' do
      login_user_from_let
      before { get :edit, group_id: group.id, initiative_id: initiative.id, id: initiative_expense.id }


      it 'returns valid expense object' do
        expect(assigns[:expense]).to be_valid
      end

      it 'set valid group object' do
        expect(assigns[:group]).to be_valid
      end

      it 'set valid initiative object' do
        expect(assigns[:initiative]).to be_valid
      end

      it 'renders edit template' do
        expect(response).to render_template :edit
      end
    end

    context 'with user not logged in' do
      before { get :edit, group_id: group.id, initiative_id: initiative.id, id: initiative_expense.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'PATCH#update' do
    describe 'with user logged in' do
      login_user_from_let

      context 'with valid attributes' do
        before { patch :update, group_id: group.id, initiative_id: initiative.id, id: initiative_expense.id, initiative_expense: { amount: 1000 } }

        it 'redirects to action index' do
          expect(response).to redirect_to action: :index
        end

        it 'flashes a notice message' do
          expect(flash[:notice]).to eq 'Your expense was updated'
        end

        it 'updates an expense' do
          initiative_expense.reload
          expect(initiative_expense.amount).to eq(1000)
        end
      end

      context 'with invalid attributes' do
        before { patch :update, group_id: group.id, initiative_id: initiative.id, id: initiative_expense.id, initiative_expense: { amount: -1 } }

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your expense was not updated. Please fix the errors'
        end

        it 'renders edit template' do
          expect(response).to render_template :edit
        end
      end
    end

    describe 'with a user not logged in' do
      before { patch :update, group_id: group.id, initiative_id: initiative.id, id: initiative_expense.id, initiative_expense: { amount: 1000 } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'DELETE#destroy' do
    context 'with a logged in user' do
      login_user_from_let

      it 'redirects to action index' do
        delete :destroy, group_id: group.id, initiative_id: initiative.id, id: initiative_expense.id, initiative_expense: { amount: 1000 }
        expect(response).to redirect_to action: :index
      end

      it 'updates an expense' do
        delete :destroy, group_id: group.id, initiative_id: initiative.id, id: initiative_expense.id, initiative_expense: { amount: 1000 }
        expect(InitiativeExpense.where(id: initiative_expense.id).count).to eq(0)
      end
    end

    describe 'with user not logged in' do
      before { delete :destroy, group_id: group.id, initiative_id: initiative.id, id: initiative_expense.id, initiative_expense: { amount: 1000 } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
