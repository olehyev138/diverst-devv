require 'rails_helper'

RSpec.describe PollResponsesController, type: :controller do
  include ActiveJob::TestHelper
  
  let(:user) { create(:user) }
  let(:poll) { create(:poll) }
  let(:poll_response) { create :poll_response, poll: poll }

  # NOTE: index method in corresponding controller has no template to render.
  # A test for index method will result in ActionView::MissingTemplate


  describe 'GET#new' do
    context 'with logged user' do
      login_user_from_let
      before { get :new, poll_id: poll.id }

      it 'render a new template' do
        expect(response).to render_template :new
      end

      it 'creates a new poll_response object' do
        expect(assigns[:response]).to be_a_new(PollResponse)
      end
    end

    context 'without a logged in user' do
      before { get :new, poll_id: poll.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'POST#create' do
    let!(:poll_response) { attributes_for(:poll_response) }
    let!(:reward_action) { create(:reward_action, enterprise: user.enterprise, key: 'survey_response', points: 40) }

    describe 'with logged user' do
      login_user_from_let

      context 'with valid params' do
        it 'creates a new poll_response' do
          expect { post :create, poll_id: poll.id, poll_response: poll_response }.to change(PollResponse.where(poll: poll, user: user), :count).by(1)
        end

        it 'rewards a user with points of this action' do
          expect(user.points).to eq 0

          post :create, poll_id: poll.id, poll_response: poll_response

          user.reload
          expect(user.points).to eq 40
        end

        it 'flashes a reward message' do
          user.enterprise.update(enable_rewards: true)
          post :create, poll_id: poll.id, poll_response: poll_response
          user.reload
          expect(flash[:reward]).to eq "Now you have #{user.credits} points"
        end

        it 'redirects to new action' do
          post :create, poll_id: poll.id, poll_response: poll_response
          expect(response).to redirect_to action: :thank_you, id: PollResponse.last
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect {
                post :create, poll_id: poll.id, poll_response: poll_response
              }.to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { PollResponse.last }
            let(:owner) { user }
            let(:key) { 'poll_response.create' }

            before {
              perform_enqueued_jobs do
                post :create, poll_id: poll.id, poll_response: poll_response
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'when saving a response object fails' do
        before do
          allow_any_instance_of(PollResponse).to receive(:save).and_return(false)
          post :create, poll_id: poll.id, poll_response: poll_response
        end

        it 'render new template' do
          expect(response).to render_template :new
        end
      end
    end

    describe 'without a logged in user' do
      before { post :create, poll_id: poll.id, poll_response: poll_response }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'PATCH#update' do
    context 'with valid params' do
      before { patch :update, poll_id: poll.id, id: poll_response.id, poll_response: { anonymous: false } }

      it 'updates a poll_response' do
        poll_response.reload
        expect(poll_response.anonymous).to eq false
      end

      it 'renders edit template' do
        expect(response).to redirect_to assigns[:poll]
      end
    end
  end


  describe 'GET#thank_you' do
    context 'with logged in user' do
      login_user_from_let

      before { get :thank_you, poll_id: poll.id, id: poll_response.id }

      it 'renders thank_you template' do
        expect(response).to render_template :thank_you
      end
    end

    context 'without logged in user' do
      before { get :thank_you, poll_id: poll.id, id: poll_response.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'DELETE#destroy' do
    context 'successfull delete poll response' do
      it 'redirect to index action' do
        delete :destroy, poll_id: poll.id, id: poll_response.id
        expect(response.status).to eq(302)
      end

      it 'deletes poll response' do
        poll_response
        expect { delete :destroy, poll_id: poll.id, id: poll_response.id }.to change(PollResponse, :count).by(-1)
      end
    end
  end
end
