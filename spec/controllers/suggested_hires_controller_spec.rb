require 'rails_helper'

RSpec.describe SuggestedHiresController, type: :controller do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let!(:suggested_hire) { create(:suggested_hire, group_id: group.id, user_id: user.id) }

  describe 'GET#index' do
    context 'with user logged in' do
      login_user_from_let
      before { get :index, group_id: group.id }

      it 'renders index template' do
        expect(response).to render_template(:index)
      end

      it 'returns suggested hires for a group' do
        expect(assigns[:suggested_hires]).to eq([suggested_hire])
      end
    end
  end

  describe 'POST#create' do
    context 'with correct params' do
      login_user_from_let

      it 'create a suggested hire object' do
        expect { post :create, group_id: group.id, suggested_hire: { email: 'derek@diverst.com' } }.to change(SuggestedHire, :count).by(1)
      end

      it 'displays a flash notice' do
        post :create, group_id: group.id, suggested_hire: { email: 'derek@diverst.com' }
        expect(flash[:notice]).to eq('You just suggested a hire')
      end

      it 'redirects to group show page' do
        post :create, group_id: group.id, suggested_hire: { email: 'derek@diverst.com' }
        expect(response).to redirect_to group_path(group)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { post :create, group_id: group.id, suggested_hire: { email: 'derek@diverst.com' } }.to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { group }
          let(:owner) { user }
          let(:key) { 'group.suggest_a_hire' }

          before {
            perform_enqueued_jobs do
              post :create, group_id: group.id, suggested_hire: { email: 'derek@diverst.com' }
            end
          }

          include_examples 'correct public activity'
        end
      end
    end

    context 'with incorrect params' do
      login_user_from_let

      it 'does not create suggested hire object' do
        expect { post :create, group_id: group.id, suggested_hire: { email: '' } }.to change(SuggestedHire, :count).by(0)
      end

      it 'displays flash alert message' do
        post :create, group_id: group.id, suggested_hire: { email: '' }
        expect(flash[:alert]).to eq('Something went wrong')
      end

      it 'redirects to group show page' do
        post :create, group_id: group.id, suggested_hire: { email: '' }
        expect(response).to redirect_to group_path(group)
      end
    end
  end

  describe 'GET#edit' do
    context 'with logged in user' do
      login_user_from_let
      before { get :edit, id: suggested_hire.id, group_id: group.id }

      it 'renders edit template' do
        expect(response).to render_template(:edit)
      end

      it 'returns suggested hire object' do
        suggested_hire.reload
        expect(assigns[:suggested_hire]).to eq(suggested_hire)
      end
    end
  end

  describe 'PATCH#update' do
    context 'with correct params' do
      login_user_from_let
      before { patch :update, id: suggested_hire.id, group_id: group.id, suggested_hire: { email: 'derek@diverst.com' } }

      it 'updates suggested hire' do
        suggested_hire.reload
        expect(assigns[:suggested_hire].email).to eq('derek@diverst.com')
      end

      it 'renders edit template' do
        expect(response).to redirect_to suggested_hires_path(group_id: group.id)
      end

      it 'renders flash notice message' do
        expect(flash[:notice]).to eq('Suggested hire was updated')
      end
    end

    context 'with incorrect params' do
      login_user_from_let
      before { patch :update, id: suggested_hire.id, group_id: group.id, suggested_hire: { email: nil } }

      it 'does not update suggested hire' do
        suggested_hire.reload
        expect(suggested_hire).to eq(suggested_hire)
      end

      it 'renders edit template' do
        expect(response).to render_template(:edit)
      end

      it 'renders flash alert message' do
        expect(flash[:alert]).to eq('Suggested hire was not updated. Please fix the errors')
      end
    end
  end

  describe 'DELETE#destroy' do
    context 'with logged in user' do
      login_user_from_let

      it 'redirects to suggested hire path' do
        delete :destroy, id: suggested_hire.id, group_id: group.id
        expect(response).to redirect_to suggested_hires_path(group_id: group.id)
      end

      it 'deletes suggested hire object' do
        expect { delete :destroy, id: suggested_hire.id, group_id: group.id }.to change(SuggestedHire, :count).by(-1)
      end
    end
  end
end
