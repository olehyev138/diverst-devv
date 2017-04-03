require 'rails_helper'

RSpec.describe User::UsersController, type: :controller do
  let(:user) { create :user }

  describe 'GET #show' do
    login_user_from_let

    it 'assigns current_user to @user' do
      get :show, id: user.id
      expect(assigns(:user)).to eq user
    end
  end

  describe 'GET #edit' do
    context 'with logged user' do
      login_user_from_let

      it 'assigns current_user to @user' do
        get :edit, id: user.id
        expect(assigns(:user)).to eq user
      end
    end

    context 'without logged user' do
      it 'returns an error' do
        get :edit, id: user.id
        expect(response).to_not be_success
      end
    end
  end

  describe 'PATCH #update' do
    context 'with logged in user' do
      let(:user) { create :user, first_name: "Name" }
      login_user_from_let

      context 'with correct params' do
        before(:each) do
          patch :update, id: user.id, user: { first_name: 'New name' }
        end

        it 'updates fields of user' do
          user.reload
          expect(user.first_name).to eq 'New name'
        end

        it 'redirects to the correct page' do
          expect(response).to redirect_to user_user_path(user)
        end
      end

      context 'with incorrect params' do
        before { patch :update, id: user.id, user: { first_name: nil } }

        it 'does not update the user' do
          user.reload
          expect(user.first_name).to eq 'Name'
        end

        it 'renders edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    context 'without logged in user' do
      before { patch :update, id: user.id }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end
end
