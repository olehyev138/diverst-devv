require 'rails_helper'

RSpec.describe MentoringSessionCommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:mentee) { create(:user) }
  let!(:mentoring_session) { create(:mentoring_session, creator: user, start: Date.today, end: Date.tomorrow + 1.day, status: 'scheduled', format: 'Video') }
  let!(:mentorship_session) { mentoring_session.mentorship_sessions.create(user: user, mentoring_session: mentoring_session, role: 'presenter') }
  let!(:mentorship_session2) { mentoring_session.mentorship_sessions.create(user: mentee, mentoring_session: mentoring_session, role: 'presenter', status: 'accepted') }
  let!(:mentoring_session_comment) { create(:mentoring_session_comment, mentoring_session: mentoring_session, user: user) }


  describe 'GET#edit' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :edit, mentoring_session_id: mentoring_session.id, id: mentoring_session_comment.id }

      it 'renders edit template' do
        expect(response).to render_template 'user/mentorship/session_comments/edit'
      end

      it 'returns comment belonging to mentoring_session' do
        expect(assigns[:comment]).to eq mentoring_session_comment
        expect(assigns[:comment].mentoring_session).to eq mentoring_session
      end
    end

    context 'when user is not logged in' do
      before { get :edit, mentoring_session_id: mentoring_session.id, id: mentoring_session_comment.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'PATCH#update' do
    context 'with valid attributes' do
      login_user_from_let

      before do
        patch :update, mentoring_session_id: mentoring_session.id, id: mentoring_session_comment.id, mentoring_session_comment: { content: 'updated' }
      end

      it 'updates the comment' do
        mentoring_session_comment.reload
        expect(assigns[:comment].content).to eq 'updated'
      end

      it 'flashes a notice message' do
        expect(flash[:notice]).to eq 'Your comment was updated'
      end

      it 'redirect to message' do
        expect(response).to redirect_to mentoring_session_path(mentoring_session.id)
      end
    end

    context 'with invalid attributes' do
      login_user_from_let
      before do
        patch :update, mentoring_session_id: mentoring_session.id, id: mentoring_session_comment.id, mentoring_session_comment: { content: nil }
      end

      it 'flashes an alert message' do
        expect(flash[:alert]).to eq 'Your comment was not updated. Please fix the errors'
      end

      it 'renders edit template' do
        expect(response).to render_template 'user/mentorship/session_comments/edit'
      end
    end

    context 'when user is not logged in' do
      before { patch :update, mentoring_session_id: mentoring_session.id, id: mentoring_session_comment.id, mentoring_session_comment: { content: 'updated' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'DELETE#destroy' do
    context 'when user is logged in' do
      login_user_from_let

      before do
        delete :destroy, mentoring_session_id: mentoring_session.id, id: mentoring_session_comment.id
      end

      it 'removes the comment' do
        expect { MentoringSessionComment.find(mentoring_session_comment.id) }.to raise_error ActiveRecord::RecordNotFound
      end

      it 'redirect to mentoring session' do
        expect(response).to redirect_to mentoring_session_path(mentoring_session.id)
      end
    end

    context 'when user is not logged in' do
      before do
        delete :destroy, mentoring_session_id: mentoring_session.id, id: mentoring_session_comment.id
      end

      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
