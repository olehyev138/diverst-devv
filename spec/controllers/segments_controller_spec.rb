require 'rails_helper'

RSpec.describe SegmentsController, type: :controller do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }
  let!(:segment) { create(:segment, enterprise: enterprise) }
  let!(:other_segment) { create(:segment, enterprise: create(:enterprise)) }

  describe 'GET#index' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :index }

      it 'render index template' do
        expect(response).to render_template :index
      end

      it 'returns list of segments' do
        expect(assigns[:segments]).to eq [segment]
      end
    end

    context 'when user is not logged in' do
      before { get :index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #get_all_segments' do
    context 'with logged user' do
      let!(:segment2) { create(:segment, enterprise: enterprise) }
      login_user_from_let

      before { get :get_all_segments, format: :json }

      it 'returns all segments' do
        expect(assigns[:segments]).to match_array([segment, segment2])
      end

      it 'returns in the proper json format' do
        parsed_body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expect(parsed_body[0]['id']).to eq(segment.id)
        expect(parsed_body[0]['text']).to eq(segment.name)
        expect(parsed_body[1]['id']).to eq(segment2.id)
        expect(parsed_body[1]['text']).to eq(segment2.name)
      end
    end

    context 'without logged user' do
      before { get :get_all_segments, format: :json }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#new' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :new }

      it 'render show template' do
        expect(response).to render_template :show
      end

      it 'returns new segement object' do
        expect(assigns[:segment]).to be_a_new(Segment)
      end
    end

    context 'when user is not logged in' do
      before { get :new }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#create' do
    describe 'when user is logged in' do
      login_user_from_let

      context 'successfully create' do
        let!(:segment_attributes) { attributes_for(:segment) }

        xit 'redirects' do
          post :create, segment: segment_attributes
          expect(response).to render_template: :show
        end

        it 'creates segment' do
          expect { post :create, segment: segment_attributes }.to change(Segment, :count).by(1)
        end

        it 'flashes a notice message' do
          post :create, segment: segment_attributes
          expect(flash[:notice]).to eq "Your #{c_t(:segment)} was created"
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { post :create, segment: segment_attributes }
                .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { Segment.last }
            let(:owner) { user }
            let(:key) { 'segment.create' }

            before {
              perform_enqueued_jobs do
                post :create, segment: segment_attributes
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'unsuccessful create' do
        let!(:invalid_segment_attributes) { { name: nil } }
        before { post :create, segment: invalid_segment_attributes }

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq "Your #{c_t(:segment)} was not created. Please fix the errors"
        end

        it 'renders show template' do
          expect(response).to render_template :show
        end
      end
    end

    describe 'when user is not logged in' do
      let!(:segment_attributes) { attributes_for(:segment) }
      before { post :create, segment: segment_attributes }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#show' do
    describe 'when user is logged in' do
      let!(:user1) { create(:user, enterprise: enterprise) }
      let!(:user2) { create(:user, enterprise: enterprise) }
      let!(:user3) { create(:user, enterprise: enterprise) }
      let!(:users_segment1) { create(:users_segment, segment: segment, user: user1) }
      let!(:users_segment2) { create(:users_segment, segment: segment, user: user2) }
      let!(:users_segment3) { create(:users_segment, segment: segment, user: user3) }
      login_user_from_let
    end

    describe 'when user is not logged in' do
      before { get :show, id: segment.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#edit' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :edit, id: segment.id }

      it 'render show template' do
        expect(response).to render_template :show
      end

      it 'returns a valid segment' do
        expect(assigns[:segment]).to be_valid
      end
    end

    context 'when user is not logged in' do
      before { get :edit, id: segment.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#update' do
    describe 'when user is logged in' do
      login_user_from_let

      context 'successfully' do
        before { patch :update, id: segment.id, segment: { name: 'updated' } }

        it 'redirects to segment show page' do
          expect(response).to redirect_to(segment)
        end

        it 'updates a segment' do
          segment.reload
          expect(segment.name).to eq('updated')
        end

        it 'flashes a notice message' do
          expect(flash[:notice]).to eq "Your #{c_t(:segment)} was updated"
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { patch :update, id: segment.id, segment: { name: 'updated' } }
                .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { segment }
            let(:owner) { user }
            let(:key) { 'segment.update' }

            before {
              perform_enqueued_jobs do
                patch :update, id: segment.id, segment: { name: 'updated' }
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'unsuccessfully' do
        before { patch :update, id: segment.id, segment: { name: nil } }

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq "Your #{c_t(:segment)} was not updated. Please fix the errors"
        end

        it 'render show template' do
          expect(response).to render_template :show
        end
      end
    end

    describe 'when user is not logged in' do
      before { patch :update, id: segment.id, segment: { name: 'updated' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'DELETE#destroy' do
    context 'when user is logged in' do
      login_user_from_let

      it 'deletes segment' do
        expect { delete :destroy, id: segment.id }.to change(Segment, :count).by(-1)
      end

      it 'redirect to action index' do
        delete :destroy, id: segment.id
        expect(response).to redirect_to action: :index
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { delete :destroy, id: segment.id }
              .to change(PublicActivity::Activity, :count).by(1)
          end
        end

        xdescribe 'activity record' do
          let(:model) { segment }
          let(:owner) { user }
          let(:key) { 'segment.destroy' }

          before {
            perform_enqueued_jobs do
              delete :destroy, id: segment.id
            end
          }

          include_examples 'correct public activity'
        end
      end
    end

    context 'when user is not logged in' do
      before { delete :destroy, id: segment.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#export_csv' do
    context 'when user is logged in' do
      login_user_from_let

      before {
        allow(SegmentMembersDownloadJob).to receive(:perform_later)
        request.env['HTTP_REFERER'] = 'back'
        get :export_csv, id: segment.id
      }

      it 'redirects to user' do
        expect(response).to redirect_to 'back'
      end

      it 'flashes' do
        expect(flash[:notice]).to eq 'Please check your Secure Downloads section in a couple of minutes'
      end

      it 'calls job' do
        expect(SegmentMembersDownloadJob).to have_received(:perform_later)
      end
    end

    context 'when user is not logged in' do
      before { get :export_csv, id: segment.id, format: :csv }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
