require 'rails_helper'

RSpec.describe ExpensesController, type: :controller do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }
  let(:category) { create(:expense_category) }
  let(:expense) { create(:expense, enterprise: enterprise) }
  let(:expense_category_1) { create(:expense_category, expense: expense) }


  describe 'GET#index' do
    context 'with logged in user' do
      login_user_from_let
      before { get :index }

      it 'returns 3 expense objects' do
        expense
        2.times { create(:expense, enterprise: enterprise) }
        expect(assigns[:expenses].count).to eq 3
      end

      it 'render index template' do
        expect(response).to render_template :index
      end
    end

    context 'without a logged in user' do
      before { get :index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET#new' do
    context 'with logged in user' do
      login_user_from_let
      before { get :new }

      it 'returns a new expense object' do
        expect(assigns[:expense]).to be_a_new(Expense)
      end

      it 'renders a new template' do
        expect(response).to render_template :new
      end
    end

    context 'without a logged in user' do
      before { get :new }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'POST#create' do
    describe 'with logged in user' do
      login_user_from_let

      context 'with correct params' do
        let(:valid_expense_attributes) { attributes_for(:expense, category_id: category.id) }

        it 'redirects to correct action' do
          post :create, expense: valid_expense_attributes
          expect(response).to redirect_to action: :index
        end

        it 'creates new expense' do
          expect {
            post :create, expense: valid_expense_attributes
          }.to change(Expense, :count).by(1)
        end

        it 'flashes a notice message' do
          post :create, expense: valid_expense_attributes
          expect(flash[:notice]).to eq 'Your expense was created'
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { post :create, expense: valid_expense_attributes }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { Expense.last }
            let(:owner) { user }
            let(:key) { 'expense.create' }

            before {
              perform_enqueued_jobs do
                post :create, expense: valid_expense_attributes
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'with invalid params' do
        let(:invalid_expense_attributes) { attributes_for(:expense, name: nil) }

        before { post :create, expense: invalid_expense_attributes }

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your expense was not created. Please fix the errors'
        end

        it 'renders new template' do
          expect(response).to render_template :new
        end
      end
    end

    describe 'without a logged in user' do
      let(:valid_expense_attributes) { attributes_for(:expense, category_id: category.id) }
      before { post :create, expense: valid_expense_attributes }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET#edit' do
    context 'with logged in user' do
      login_user_from_let
      before { get :edit, id: expense.id }

      it 'returns a valid expense object' do
        expect(assigns[:expense]).to be_valid
      end

      it 'renders an edit template' do
        expect(response).to render_template :edit
      end
    end

    context 'without a logged in user' do
      before { get :edit, id: expense.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'PATCH#update' do
    describe 'with logged in user' do
      before { request.env['HTTP_REFERER'] = 'back' }
      login_user_from_let

      context 'with valid parameters' do
        before { patch :update, id: expense.id, expense: attributes_for(:expense, name: 'updated') }

        it 'updates the expense' do
          expense.reload
          expect(expense.name).to eq 'updated'
        end

        it 'redirects to action index' do
          expect(response).to redirect_to action: :index
        end

        it 'flashes a notice message' do
          expect(flash[:notice]).to eq 'Your expense was updated'
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { patch :update, id: expense.id, expense: attributes_for(:expense, name: 'updated') }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { expense }
            let(:owner) { user }
            let(:key) { 'expense.update' }

            before {
              perform_enqueued_jobs do
                patch :update, id: expense.id, expense: attributes_for(:expense, name: 'updated')
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'with invalid parameters' do
        before { patch :update, id: expense.id, expense: attributes_for(:expense, name: '') }

        it 'does not update the expense' do
          expense.reload
          expect(expense.name).to_not eq ''
        end

        it 'renders action edit' do
          expect(response).to render_template :edit
        end

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your expense was not updated. Please fix the errors'
        end
      end
    end

    describe 'wtihout a logged in user' do
      before { patch :update, id: expense.id, expense: attributes_for(:expense, name: 'updated') }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'DELETE#destroy' do
    context 'with logged in user' do
      login_user_from_let

      it 'redirects to action: :index' do
        delete :destroy, id: expense.id
        expect(response).to redirect_to action: :index
      end

      it 'destroys expense' do
        expense
        expect { delete :destroy, id: expense.id }.to change(Expense, :count).by(-1)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { delete :destroy, id: expense.id }
            .to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { expense }
          let(:owner) { user }
          let(:key) { 'expense.destroy' }

          before {
            perform_enqueued_jobs do
              delete :destroy, id: expense.id
            end
          }

          include_examples 'correct public activity'
        end
      end
    end

    context 'without logged in user' do
      before { delete :destroy, id: expense.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
