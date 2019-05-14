require 'rails_helper'

RSpec.describe ClockworkDatabaseEventsController, type: :controller do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }
  let!(:clockwork_database_event) { create(:clockwork_database_event, enterprise: enterprise) }

  describe 'GET#index' do
    context 'with logged in user' do
      login_user_from_let
      before { get :index }

      it 'render index template' do
        expect(response).to render_template :index
      end

      it 'return enterprise of current user' do
        expect(assigns[:enterprise]).to eq user.enterprise
      end

      it 'returns events belonging to enterprise' do
        expect(assigns[:clockwork_database_events].length).to eq 1
      end
    end

    context 'without a logged in user' do
      before { get :index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#update' do
    describe 'with logged in user' do
      login_user_from_let

      context 'with valid parameters' do
        before {
          perform_enqueued_jobs do
            patch :update, id: clockwork_database_event.id, clockwork_database_event: { name: 'updated' }
          end
        }

        it 'updates the clockwork_database_event' do
          clockwork_database_event.reload
          expect(clockwork_database_event.name).to eq 'updated'
        end

        it 'redirects to action index' do
          expect(response).to redirect_to action: :index
        end

        it 'flashes a notice message' do
          expect(flash[:notice]).to eq 'Your email event was updated'
        end

        xit 'track activity of clockwork_database_event', skip: 'NEED TO INVESTIGATE WHY IT DOESNT WORK' do
          expect(PublicActivity::Activity.where(owner_id: user.id, recipient_id: user.enterprise.id, trackable_type: 'ClockworkDatabaseEvent', key: 'clockwork_database_event.update').count).to eq(1)
        end
      end

      context 'with invalid parameters' do
        before { patch :update, id: clockwork_database_event.id, clockwork_database_event: { name: nil } }

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your email event was not updated. Please fix the errors'
        end

        it 'renders edit template' do
          expect(response).to render_template :edit
        end
      end
    end

    describe 'without a logged in user' do
      before { patch :update, id: clockwork_database_event.id, clockwork_database_event: { name: 'updated' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
