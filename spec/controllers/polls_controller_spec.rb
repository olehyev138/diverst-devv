require 'rails_helper'

RSpec.describe PollsController, type: :controller do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }
  let!(:poll) { build(:poll, status: 0, enterprise: user.enterprise, groups: []) }

  describe 'GET#index' do
    before { poll.save }

    context 'with logged user' do
      login_user_from_let
      before { get :index }

      it 'gets the index' do
        expect(response).to render_template :index
      end

      it 'displays all polls' do
        expect(assigns[:polls]).to eq [poll]
      end
    end

    context 'without a logged in user' do
      before { get :index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#new' do
    context 'with logged user' do
      login_user_from_let
      before { get :new }

      it 'renders new template' do
        expect(response).to render_template :new
      end

      it 'returns a new poll object' do
        expect(assigns[:poll]).to be_a_new(Poll)
      end
    end

    context 'without a logged in user' do
      before { get :new }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#create' do
    describe 'with logged user' do
      login_user_from_let

      context 'with valid params' do
        let(:poll_attributes) { attributes_for(:poll, fields_attributes: [attributes_for(:field)]) }
        enable_public_activity

        it 'creates a new poll' do
          expect { post :create, poll: poll_attributes }.to change(Poll.where(owner_id: user.id), :count).by(1)
        end

        it 'track activity of poll' do
          perform_enqueued_jobs do
            expect { post :create, poll: poll_attributes }.to change(PublicActivity::Activity
              .where(owner_id: user.id, recipient_id: user.enterprise.id, trackable_type: 'Poll', key: 'poll.create'), :count).by(1)
          end
        end

        it 'redirects to index action' do
          post :create, poll: poll_attributes
          expect(response).to redirect_to action: :index
        end

        it 'flashes a notice message' do
          post :create, poll: poll_attributes
          expect(flash[:notice]).to eq 'Your survey was created'
        end
      end

      context 'with invalid params' do
        let(:poll_attributes) { attributes_for(:poll, status: nil, fields_attributes: [attributes_for(:field)]) }

        it 'does not create a new poll' do
          expect { post :create, poll: poll_attributes }.to change(Poll, :count).by(0)
        end

        it 'renders the new action' do
          post :create, poll: poll_attributes
          expect(response).to render_template :new
        end

        it 'flashes an alert message' do
          post :create, poll: poll_attributes
          expect(flash[:alert]).to eq "#{assigns[:poll].errors.full_messages.first}"
        end
      end
    end

    describe 'without a logged in user' do
      before { post :create, poll: poll_attributes }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#show' do
    before { poll.save }

    context 'with logged user' do
      login_user_from_let

      let!(:graph1) { create(:graph_with_metrics_dashboard, poll_id: poll.id, aggregation: create(:field, poll_id: poll.id)) }
      let!(:graph2) { create(:graph_with_metrics_dashboard, poll_id: poll.id, aggregation: create(:field, poll_id: poll.id)) }

      before { get :show, id: poll.id }

      it 'sets a valid poll object' do
        expect(assigns[:poll]).to be_valid
      end

      it 'display graphs of a particular poll' do
        expect(assigns[:graphs].last(2)).to eq [graph1, graph2]
      end

      it 'returns poll responses in a decreasing order of created_at' do
        response1 = create(:poll_response, poll: poll, user: user)
        response2 = create(:poll_response, poll: poll, user: user, created_at: DateTime.now + 1.minute, updated_at: DateTime.now + 1.minute)
        expect(assigns[:responses]).to eq [response2, response1]
      end

      it 'render show template' do
        expect(response).to render_template :show
      end
    end

    context 'without a logged in user' do
      before { get :show, id: poll.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#edit' do
    before { poll.save }

    context 'with logged user' do
      login_user_from_let
      before { get :edit, id: poll.id }

      it 'set a valid poll object' do
        expect(assigns[:poll]).to be_valid
      end

      it 'render edit template' do
        expect(response).to render_template :edit
      end
    end

    context 'without a logged in user' do
      before { get :edit, id: poll.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#update' do
    before { poll.save }

    let(:group) { create(:group, enterprise: user.enterprise) }
    enable_public_activity

    describe 'with logged user' do
      login_user_from_let

      context 'with valid params' do
        before { patch :update, id: poll.id, poll: { group_ids: [group.id] } }

        it 'updates the poll' do
          poll.reload
          expect(poll.groups).to eq [group]
        end

        it 'track activity of poll' do
          perform_enqueued_jobs do
            expect { patch :update, id: poll.id, poll: { group_ids: [group.id] } }.to change(PublicActivity::Activity.where(
              owner_id: user.id, recipient_id: user.enterprise.id, trackable_type: 'Poll', trackable_id: poll.id, key: 'poll.update'
            ), :count).by(1)
          end
        end

        it 'flashes a notice message' do
          expect(flash[:notice]).to eq 'Your survey was updated'
        end

        it 'redirects to the updated poll' do
          expect(response).to redirect_to(poll)
        end
      end

      context 'with invalid params' do
        let(:group) { create(:group) }
        before(:each) do
          patch :update, id: poll.id, poll: { group_ids: [group.id] }
        end

        it 'does not update the poll' do
          poll.reload
          expect(poll.groups).to eq []
        end

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your survey was not updated. Please fix the errors'
        end

        it 'renders the edit action' do
          expect(response).to render_template :edit
        end
      end
    end

    describe 'without a logged in user' do
      before { patch :update, id: poll.id, poll: { group_ids: [group.id] } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'DELETE#destroy', skip: 'this spec will pass when PR 1245 is merged to master' do
    before { poll.save }

    context 'with logged user' do
      login_user_from_let
      enable_public_activity

      it 'deletes a poll' do
        expect { delete :destroy, id: poll.id }.to change(Poll, :count).by(-1)
      end

      it 'redirect to index action' do
        delete :destroy, id: poll.id
        expect(response).to redirect_to action: :index
      end

      it 'tracks delete activity' do
        perform_enqueued_jobs do
          expect { delete :destroy, id: poll.id }.to change(PublicActivity::Activity.all, :count).by(1)
        end
      end
    end

    context 'without a logged in user' do
      before { delete :destroy, id: poll.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#export_csv' do
    before { poll.save }

    context 'with logged user' do
      login_user_from_let
      before {
        allow(PollDownloadJob).to receive(:perform_later)
        request.env['HTTP_REFERER'] = 'back'
        get :export_csv, id: poll.id
      }

      it 'returns to previous page' do
        expect(response).to redirect_to 'back'
      end

      it 'flashes' do
        expect(flash[:notice]).to eq 'Please check your Secure Downloads section in a couple of minutes'
      end

      it 'calls job' do
        expect(PollDownloadJob).to have_received(:perform_later)
      end
    end

    context 'without a logged in user' do
      before { get :export_csv, id: poll.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
