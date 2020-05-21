require 'rails_helper'

RSpec.describe TopicFeedbacksController, type: :controller do
  let!(:enterprise) { create(:enterprise, name: 'test') }
  let!(:user) { create(:user, enterprise: enterprise) }
  let!(:topic) { create(:topic, enterprise: enterprise) }
  let!(:topic_feedback) { create(:topic_feedback, topic: topic) }

  describe 'GET#new' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :new, topic_id: topic.id }

      it 'render new template' do
        expect(response).to render_template :new
      end

      it 'return new feedback' do
        expect(assigns[:feedback]).to be_a_new(TopicFeedback)
      end
    end

    context 'when user is not logged in' do
      before { get :new, topic_id: topic.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#create' do
    describe 'when user is logged in' do
      login_user_from_let

      context 'create succesfully' do
        let!(:topic_feedback_attributes) { attributes_for(:topic_feedback) }

        it 'redirects to thank you action' do
          post :create, topic_id: topic.id, topic_feedback: topic_feedback_attributes
          expect(response).to redirect_to action: :thank_you
        end

        it 'creates the feedback' do
          expect { post :create, topic_id: topic.id, topic_feedback: topic_feedback_attributes }.to change(TopicFeedback, :count).by(1)
        end

        it 'sets the current user as the feedback user' do
          post :create, topic_id: topic.id, topic_feedback: topic_feedback_attributes
          feedback = TopicFeedback.last
          expect(feedback.user.id).to eq(user.id)
        end
      end

      context 'create unsuccesfully' do
        let!(:topic_feedback_attributes) { attributes_for(:topic_feedback) }

        it 'redirects back' do
          request.env['HTTP_REFERER'] = 'back'
          allow_any_instance_of(TopicFeedback).to receive(:save).and_return false
          post :create, topic_id: topic.id, topic_feedback: topic_feedback_attributes
          expect(response).to redirect_to 'back'
        end
      end
    end

    describe 'when user is not logged in' do
      let!(:topic_feedback_attributes) { attributes_for(:topic_feedback) }
      before { post :create, topic_id: topic.id, topic_feedback: topic_feedback_attributes }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#update' do
    describe 'when user is logged in' do
      login_user_from_let

      context 'successfully' do
        before { patch :update, topic_id: topic.id, id: topic_feedback.id, topic_feedback: { content: 'updated' } }

        it 'returns http_status :ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'updates the feedback' do
          topic_feedback.reload
          expect(topic_feedback.content).to eq('updated')
        end
      end

      context 'unsuccessfully' do
        before {
          allow_any_instance_of(TopicFeedback).to receive(:update).and_return false
          patch :update, topic_id: topic.id, id: topic_feedback.id, topic_feedback: { content: 'updated' }
        }

        it 'has an error' do
          expect(response).to have_http_status(:internal_server_error)
        end
      end
    end

    describe 'when user is not logged in' do
      before { patch :update, topic_id: topic.id, id: topic_feedback.id, topic_feedback: { content: 'updated' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'DELETE#destroy' do
    context 'when user is logged in' do
      login_user_from_let

      before { request.env['HTTP_REFERER'] = 'back' }

      it 'redirects to previous page' do
        delete :destroy, topic_id: topic.id, id: topic_feedback.id
        expect(response).to redirect_to 'back'
      end

      it 'deletes the feedback' do
        expect { delete :destroy, topic_id: topic.id, id: topic_feedback.id }
        .to change(TopicFeedback, :count).by(-1)
      end
    end

    context 'when user is not logged in' do
      before do
        request.env['HTTP_REFERER'] = 'back'
        delete :destroy, topic_id: topic.id, id: topic_feedback.id
      end
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
