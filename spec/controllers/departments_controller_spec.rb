require 'rails_helper'

RSpec.describe DepartmentsController, type: :controller do

  let!(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }

  describe 'GET #index' do
    let!(:departments) { create_list(:department, 2, enterprise: enterprise) }

    context 'with logged in user' do
      login_user_from_let

      before { get :index }

      it 'returns categories' do
        expect(assigns[:departments]).to match_array(departments)
      end

      it 'render index template' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET #new' do
    context 'with logged in user' do
      login_user_from_let

      before { get :new }

      it 'returns new department object' do
        expect(assigns[:department]).to be_a_new(Department)
      end

      it 'renders new template' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST #create' do
    context 'with logged in user' do
      login_user_from_let

      context 'successfully' do
        it 'creates an department object' do
          expect { post :create, department: { name: 'Accounting' } }.to change(Department, :count).by(1)
        end

        it 'redirects to index' do
          post :create, department: { name: 'Accounting' }
          expect(response).to redirect_to(action: :index)
        end

        it 'displays flash notice message' do
          post :create, department: { name: 'Accounting' }
          expect(flash[:notice]).to eq('Your department was created')
        end
      end

      context 'unsuccessfully create department' do
        it 'does not create department' do
          expect { post :create, department: { name: '' } }.to change(Department, :count).by(0)
        end

        it 'displays a flash alert message' do
          post :create, department: { name: '' }
          expect(flash[:alert]).to eq('Your department was not created. Please fix the errors')
        end

        it 'renders new template' do
          post :create, department: { name: '' }
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'PATCH #update' do
    let!(:department) { create(:department, name: 'Accounting', enterprise: enterprise) }

    context 'with logged in user' do
      login_user_from_let

      context 'successfully' do
        before { patch :update, id: department.id, department: { name: 'Accounting [updated]' } }

        it 'updates an department object' do
          department.reload
          expect(department.name).to eq('Accounting [updated]')
        end

        it 'redirects to index' do
          expect(response).to redirect_to(action: :index)
        end

        it 'displays flash notice message' do
          expect(flash[:notice]).to eq('Your department was updated')
        end
      end

      context 'unsuccessfully update department' do
        before { patch :update, id: department.id, department: { name: '' } }

        it 'displays a flash alert message' do
          expect(flash[:alert]).to eq('Your department was not updated. Please fix the errors')
        end

        it 'renders edit template' do
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:department) { create(:department, name: 'Accounting', enterprise: enterprise) }

    context 'with logged in user' do
      login_user_from_let

      context 'successfully' do
        it 'deletes an department object' do
          expect { delete :destroy, id: department.id }.to change(Department, :count).by(-1)
        end

        it 'redirects to action: :index' do
          delete :destroy, id: department.id
          expect(response).to redirect_to(action: :index)
        end
      end
    end
  end
end
