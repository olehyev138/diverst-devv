require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  describe 'GET #index' do
    def get_index
      get :index
    end

    context 'with logged user' do
      login_user

      before { get_index }

      it 'return success' do
        expect(response).to be_success
      end
    end

    context 'without logged user' do
      before { get_index }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end
end
