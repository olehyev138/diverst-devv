require 'rails_helper'

RSpec.describe IdeaCategoriesController, type: :controller do
  let!(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }

  describe 'GET #index' do
    let!(:idea_categories) { create_list(:idea_category, 2, enterprise: enterprise) }

    context 'with logged in user' do
      login_user_from_let

      before { get :index }

      it 'returns categories' do
        expect(assigns[:idea_categories]).to match_array(idea_categories)
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

      it 'returns new idea category object' do
        expect(assigns[:idea_category]).to be_a_new(IdeaCategory)
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
        it 'creates an idea category object' do
          expect { post :create, idea_category: { name: 'Business Plan' } }.to change(IdeaCategory, :count).by(1)
        end

        it 'redirects to index' do
          post :create, idea_category: { name: 'Business Plan' }
          expect(response).to redirect_to(action: :index)
        end

        it 'displays flash notice message' do
          post :create, idea_category: { name: 'Business Plan' }
          expect(flash[:notice]).to eq('Your idea category was created')
        end
      end

      context 'unsuccessfully create category' do
        it 'does not create idea category' do
          expect { post :create, idea_category: { name: '' } }.to change(IdeaCategory, :count).by(0)
        end

        it 'displays a flash alert message' do
          post :create, idea_category: { name: '' }
          expect(flash[:alert]).to eq('Your idea category was not created. Please fix the errors')
        end

        it 'renders new template' do
          post :create, idea_category: { name: '' }
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'PATCH #update' do
    let!(:idea_category) { create(:idea_category, name: 'Business Plan', enterprise: enterprise) }

    context 'with logged in user' do
      login_user_from_let

      context 'successfully' do
        before { patch :update, id: idea_category.id, idea_category: { name: 'Business Plan [updated]' } }

        it 'updates an idea category object' do
          idea_category.reload
          expect(idea_category.name).to eq('Business Plan [updated]')
        end

        it 'redirects to index' do
          expect(response).to redirect_to(action: :index)
        end

        it 'displays flash notice message' do
          expect(flash[:notice]).to eq('Your idea category was updated')
        end
      end

      context 'unsuccessfully update category' do
        before { patch :update, id: idea_category.id, idea_category: { name: '' } }

        it 'displays a flash alert message' do
          expect(flash[:alert]).to eq('Your idea category was not updated. Please fix the errors')
        end

        it 'renders edit template' do
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:idea_category) { create(:idea_category, name: 'Business Plan', enterprise: enterprise) }

    context 'with logged in user' do
      login_user_from_let

      context 'successfully' do
        it 'deletes an idea category object' do
          expect { delete :destroy, id: idea_category.id }.to change(IdeaCategory, :count).by(-1)
        end

        it 'redirects to action: :index' do
          delete :destroy, id: idea_category.id
          expect(response).to redirect_to(action: :index)
        end
      end
    end
  end
end
