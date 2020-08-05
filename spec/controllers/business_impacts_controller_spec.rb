require 'rails_helper'

RSpec.describe BusinessImpactsController, type: :controller do

  let!(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }

  describe 'GET #index' do
    let!(:business_impacts) { create_list(:business_impact, 2, enterprise: enterprise) }

    context 'with logged in user' do
      login_user_from_let

      before { get :index }

      it 'returns categories' do
        expect(assigns[:business_impacts]).to match_array(business_impacts)
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

      it 'returns new business_impact object' do
        expect(assigns[:business_impact]).to be_a_new(BusinessImpact)
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
        it 'creates an business_impact object' do
          expect { post :create, business_impact: { name: 'Accounting' } }.to change(BusinessImpact, :count).by(1)
        end

        it 'redirects to index' do
          post :create, business_impact: { name: 'Accounting' }
          expect(response).to redirect_to(action: :index)
        end

        it 'displays flash notice message' do
          post :create, business_impact: { name: 'Accounting' }
          expect(flash[:notice]).to eq('Your Business Impact was created')
        end
      end

      context 'unsuccessfully create business_impact' do
        it 'does not create business_impact' do
          expect { post :create, business_impact: { name: '' } }.to change(BusinessImpact, :count).by(0)
        end

        it 'displays a flash alert message' do
          post :create, business_impact: { name: '' }
          expect(flash[:alert]).to eq('Your Business Impact was not created. Please fix the errors')
        end

        it 'renders new template' do
          post :create, business_impact: { name: '' }
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'PATCH #update' do
    let!(:business_impact) { create(:business_impact, name: 'Accounting', enterprise: enterprise) }

    context 'with logged in user' do
      login_user_from_let

      context 'successfully' do
        before { patch :update, id: business_impact.id, business_impact: { name: 'Accounting [updated]' } }

        it 'updates an business_impact object' do
          business_impact.reload
          expect(business_impact.name).to eq('Accounting [updated]')
        end

        it 'redirects to index' do
          expect(response).to redirect_to(action: :index)
        end

        it 'displays flash notice message' do
          expect(flash[:notice]).to eq('Your Business Impact was updated')
        end
      end

      context 'unsuccessfully update business_impact' do
        before { patch :update, id: business_impact.id, business_impact: { name: '' } }

        it 'displays a flash alert message' do
          expect(flash[:alert]).to eq('Your Business Impact was not updated. Please fix the errors')
        end

        it 'renders edit template' do
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:business_impact) { create(:business_impact, name: 'Accounting', enterprise: enterprise) }

    context 'with logged in user' do
      login_user_from_let

      context 'successfully' do
        it 'deletes an business_impact object' do
          expect { delete :destroy, id: business_impact.id }.to change(BusinessImpact, :count).by(-1)
        end

        it 'redirects to action: :index' do
          delete :destroy, id: business_impact.id
          expect(response).to redirect_to(action: :index)
        end
      end
    end
  end
end
