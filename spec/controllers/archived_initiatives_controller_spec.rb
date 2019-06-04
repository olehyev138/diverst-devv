require 'rails_helper'

RSpec.describe ArchivedInitiativesController, type: :controller do
  include ActiveJob::TestHelper

  let!(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }
  let!(:group) { create(:group, enterprise: enterprise) }
  let!(:archived_initiatives) { create_list(:initiative, 2, archived_at: DateTime.now, owner_group: group) }

  describe 'GET#index' do
    context 'when logged in' do
      login_user_from_let
      before { get :index }

      it 'returns archived initiatives' do
        expected = archived_initiatives.sort_by { |initiative| -1 * initiative.created_at.to_i }
        expect(assigns[:initiatives]).to eq expected
      end

      it 'returns http_status :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders index template' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'DELETE#destroy' do
    context 'when logged in' do
      login_user_from_let
      before { request.env['HTTP_REFERER'] = 'back' }

      it 'deletes archived initiative' do
        expect { delete :destroy, id: archived_initiatives.last.id }.to change(Initiative, :count).by(-1)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect {
              delete :destroy, id: archived_initiatives.last.id
            }.to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { Initiative.last }
          let(:owner) { user }
          let(:key) { 'initiative.destroy' }

          before {
            perform_enqueued_jobs do
              delete :destroy, id: archived_initiatives.last.id
            end
          }

          include_examples 'correct public activity'
        end
      end
    end
  end

  describe 'POST#delete_all' do
    context 'when logged in' do
      login_user_from_let
      before { request.env['HTTP_REFERER'] = 'back' }

      it 'deletes all archived initiatives' do
        expect { post :delete_all }.to change(Initiative, :count).by(-2)
      end
    end
  end

  describe 'POST#restore_all' do
    context 'when logged in' do
      login_user_from_let
      before { request.env['HTTP_REFERER'] = 'back' }

      it 'restores all archived initiatives' do
        expect { post :restore_all }.to change(Initiative.archived_initiatives(enterprise), :count).by(-2)
      end
    end
  end

  describe 'PATCH#restore' do
    context 'when logged in' do
      login_user_from_let
      before { request.env['HTTP_REFERER'] = 'back' }

      it 'restores an archived initiative' do
        expect { patch :restore, id: archived_initiatives.first.id }.to change(Initiative.archived_initiatives(enterprise), :count).by(-1)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect {
              delete :restore, id: archived_initiatives.last.id
            }.to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { Initiative.last }
          let(:owner) { user }
          let(:key) { 'initiative.restore' }

          before {
            perform_enqueued_jobs do
              delete :restore, id: archived_initiatives.last.id
            end
          }

          include_examples 'correct public activity'
        end
      end
    end
  end
end
