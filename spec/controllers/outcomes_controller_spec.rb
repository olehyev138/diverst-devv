require 'rails_helper'

RSpec.describe OutcomesController, type: :controller do
  let!(:enterprise) { create :enterprise }
  let!(:user) { create :user, enterprise: enterprise }
  let!(:group) { create :group, enterprise: user.enterprise }
  let!(:outcome) { create :outcome, group_id: group.id }


  describe 'GET #index' do
    def get_index(group_id = -1)
      get :index, group_id: group_id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_index(group.id) }

      it 'render index template' do
        expect(response).to render_template :index
      end

      it 'sets a valid group object' do
        expect(assigns[:group]).to be_valid
      end
    end

    context 'with non-logged in user' do
      before { get_index(group.id) }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  # NOTE: MISSING  TEMPLATE for new action
  # NOTE: TEMPLATE exists for edit action. However, form partial is missing


  describe 'POST #create' do
    def post_create(group_id = -1)
      post :create, group_id: group_id, outcome: { name: 'created', group_id: group.id }
    end

    describe 'with logged user' do
      login_user_from_let

      context 'with valid params' do
        it 'redirects to index' do
          post_create(group.id)
          expect(response).to redirect_to action: :index
        end

        it 'creates the outcome' do
          expect { post_create(group.id) }.to change(Outcome, :count).by(1)
        end

        it 'flashes a notice message' do
          post_create(group.id)
          expect(flash[:notice]).to eq "Your #{ c_t(:outcome) } was created"
        end
      end
    end


    describe 'without logged in user' do
      before { post :create, group_id: group.id, outcome: { name: 'created', group_id: group.id } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'PATCH #update' do
    def patch_update(group_id = -1)
      patch :update, group_id: group_id, id: outcome.id, outcome: { name: 'updated' }
    end

    describe 'with logged user' do
      login_user_from_let

      context 'with valid params' do
        before { patch_update(group.id) }

        it 'redirects to index' do
          expect(response).to redirect_to action: :index
        end

        it 'updates the outcome' do
          outcome.reload
          expect(outcome.name).to eq('updated')
        end

        it 'flashes a notice message' do
          expect(flash[:notice]).to eq "Your #{ c_t(:outcome) } was updated"
        end
      end
    end

    describe 'without logged in user' do
      before { patch_update(group.id) }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'DELETE #destroy' do
    def delete_destroy(group_id = -1)
      delete :destroy, group_id: group_id, id: outcome.id
    end

    context 'with logged user' do
      login_user_from_let

      it 'redirects to index' do
        delete_destroy(group.id)
        expect(response).to redirect_to action: :index
      end

      it 'destroys outcome' do
        expect { delete_destroy(group.id) }.to change(Outcome, :count).by(-1)
      end
    end

    context 'without logged user' do
      before { delete_destroy(group.id) }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
