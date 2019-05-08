require 'rails_helper'

RSpec.describe ExpenseCategoriesController, type: :controller do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:expense_category) { create(:expense_category, enterprise: enterprise) }

  describe 'GET#index' do
    context 'with logged in user' do
      login_user_from_let

      before { get :index }

      it 'returns 3 expense categories' do
        expense_category
        2.times { create(:expense_category, enterprise: enterprise) }
        expect(assigns[:expense_categories].count).to eq 3
      end

      it 'render index template' do
        expect(response).to render_template :index
      end
    end

    context 'without logged in user' do
      before { get :index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET#new' do
    context 'with logged in user' do
      login_user_from_let
      before { get :new }

      it 'returns a new expense category object' do
        expect(assigns[:expense_category]).to be_a_new(ExpenseCategory)
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
        let(:valid_expense_category_attributes) { attributes_for(:expense_category) }

        it 'redirects to correct action' do
          post :create, expense_category: valid_expense_category_attributes
          expect(response).to redirect_to action: :index
        end

        it 'creates new expense_category' do
          expect {
            post :create, expense_category: valid_expense_category_attributes
          }.to change(ExpenseCategory, :count).by(1)
        end

        it 'flashes a notice message' do
          post :create, expense_category: valid_expense_category_attributes
          expect(flash[:notice]).to eq 'Your expense category was created'
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { post :create, expense_category: valid_expense_category_attributes }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { ExpenseCategory.last }
            let(:owner) { user }
            let(:key) { 'expense_category.create' }

            before {
              perform_enqueued_jobs do
                post :create, expense_category: valid_expense_category_attributes
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'with incorrect params' do
        let(:invalid_expense_category_attributes) { attributes_for(:expense_category, name: nil) }
        before { post :create, expense_category: invalid_expense_category_attributes }

        it 'renders new template' do
          expect(response).to render_template :new
        end

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your expense category was not created. Please fix the errors'
        end
      end
    end

    describe 'without a logged in user' do
      let(:valid_expense_category_attributes) { attributes_for(:expense_category) }
      before { post :create, expense_category: valid_expense_category_attributes }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET#edit' do
    context 'with logged in user' do
      login_user_from_let
      before { get :edit, id: expense_category.id }

      it 'returns valid expense category object' do
        expect(assigns[:expense_category]).to be_valid
      end

      it 'renders edit template' do
        expect(response).to render_template :edit
      end
    end

    context 'without a logged in user' do
      before { get :edit, id: expense_category.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'PATCH#update' do
    describe 'with logged in user' do
      before { request.env['HTTP_REFERER'] = 'back' }
      login_user_from_let

      context 'with valid parameters' do
        before { patch :update, id: expense_category.id, expense_category: { name: 'updated' } }

        it 'updates the expense_category' do
          expense_category.reload
          expect(expense_category.name).to eq 'updated'
        end

        it 'redirects to action index' do
          expect(response).to redirect_to action: :index
        end

        it 'flashes notice message' do
          expect(flash[:notice]).to eq 'Your expense category was updated'
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { patch :update, id: expense_category.id, expense_category: { name: 'updated' } }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { expense_category }
            let(:owner) { user }
            let(:key) { 'expense_category.update' }

            before {
              perform_enqueued_jobs do
                patch :update, id: expense_category.id, expense_category: { name: 'updated' }
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'with invalid parameters' do
        before { patch :update, id: expense_category.id, expense_category: { name: nil } }

        it 'renders action edit' do
          expect(response).to render_template :edit
        end

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your expense category was not updated. Please fix the errors'
        end
      end
    end

    describe 'without a logged in user' do
      before { patch :update, id: expense_category.id, expense_category: { name: 'updated' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'DELETE#destroy' do
    context 'with logged in user' do
      login_user_from_let

      it 'redirect to action: :index' do
        delete :destroy, id: expense_category.id
        expect(response).to redirect_to action: :index
      end

      it 'destroy the expense_category' do
        expense_category
        expect { delete :destroy, id: expense_category.id }.to change(ExpenseCategory, :count).by(-1)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { delete :destroy, id: expense_category.id }
            .to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { expense_category }
          let(:owner) { user }
          let(:key) { 'expense_category.destroy' }

          before {
            perform_enqueued_jobs do
              delete :destroy, id: expense_category.id
            end
          }

          include_examples 'correct public activity'
        end
      end
    end

    context 'without logged in user' do
      before { delete :destroy, id: expense_category.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
