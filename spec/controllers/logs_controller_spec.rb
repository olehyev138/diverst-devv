require 'rails_helper'

RSpec.describe LogsController, type: :controller do
  include ActiveJob::TestHelper

  describe 'GET #index' do
    def get_index
      get :index
    end

    context 'with logged user' do
      let(:user) { create :user }
      let(:enterprise1) { user.enterprise }
      let(:enterprise2) { create :enterprise }

      let(:initiative1) { create :initiative }
      let(:initiative2) { create :initiative }

      let!(:activity1) {
        PublicActivity::Activity.create(
          trackable_id: initiative1.id,
          trackable_type: initiative1.class.to_s,
          key: 'initiative.create',
          recipient: enterprise1
        )
      }
      let!(:activity2) {
        PublicActivity::Activity.create(
          trackable_id: initiative2.id,
          trackable_type: initiative2.class.to_s,
          key: 'initiative.create',
          recipient: enterprise2
        )
      }
      login_user_from_let

      context 'html output' do
        before { get_index }

        it 'returns success' do
          expect(response).to be_success
        end

        it 'return html format' do
          expect(response.content_type).to eq 'text/html'
        end

        describe 'enterprise' do
          it 'only shows records from current enterprise' do
            activities = assigns(:activities)

            expect(activities).to include activity1
            expect(activities).to_not include activity2
          end
        end
      end

      context 'csv output' do
        before {
          allow(LogsDownloadJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = 'back'
          get :index, format: :csv
        }

        it 'returns to previous page' do
          expect(response).to redirect_to 'back'
        end

        it 'flashes' do
          expect(flash[:notice]).to eq 'Please check your Secure Downloads section in a couple of minutes'
        end

        it 'calls job' do
          expect(LogsDownloadJob).to have_received(:perform_later)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              allow(LogsDownloadJob).to receive(:perform_later)
              expect { get :index, format: :csv }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end
        end
      end
    end

    context 'without logged user' do
      before { get_index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
