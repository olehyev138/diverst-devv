require 'rails_helper'
require_dependency "#{::Rails.root}/app/controllers/user/users_controller"

RSpec.describe User::UsersController, type: :controller do
  let(:user) { create :user }

  describe 'GET #show' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :show, id: user.id }

      it 'renders show template' do
        expect(response).to render_template :show
      end

      it 'assigns current_user to @user' do
        expect(assigns(:user)).to eq user
      end
    end

    context 'when user is not logged in' do
      before { get :show, id: user.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET #edit' do
    context 'with logged user' do
      login_user_from_let
      before { get :edit, id: user.id }

      it 'renders edit template' do
        expect(response).to render_template :edit
      end

      it 'assigns current_user to @user' do
        expect(assigns(:user)).to eq user
      end
    end

    context 'without logged user' do
      before { get :edit, id: user.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'PATCH #update' do
    describe 'with logged in user' do
      let(:user) { create :user, first_name: 'Name' }
      login_user_from_let

      context 'with correct params' do
        before { patch :update, id: user.id, user: { first_name: 'New name' } }

        it 'updates fields of user' do
          user.reload
          expect(assigns[:user].first_name).to eq 'New name'
        end

        it 'flashes a notice message' do
          expect(flash[:notice]).to eq 'Your user was updated'
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

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your user was not updated. Please fix the errors'
        end

        it 'renders edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    describe 'without logged in user' do
      before { patch :update, id: user.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
