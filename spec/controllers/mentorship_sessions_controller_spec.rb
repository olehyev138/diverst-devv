require 'rails_helper'

RSpec.describe MentorshipSessionsController, type: :controller do
  let(:user){ create(:user) }
  let(:creator) { create(:user) }
  let(:mentoring_session){ create(:mentoring_session, creator: creator, start: Date.today, end: Date.tomorrow + 1.day, status: "scheduled", format: "Video") }
  let!(:mentorship_session){ mentoring_session.mentorship_sessions.create(:user => creator, :mentoring_session => mentoring_session, :role => "presenter") }
  let!(:mentorship_session2){ mentoring_session.mentorship_sessions.create(:user => user, :mentoring_session => mentoring_session, :role => "viewer") }

  describe 'GET#accept' do
    context 'when user is logged in' do
      login_user_from_let

      before {
        request.env["HTTP_REFERER"] = "back"
        get :accept, mentoring_session_id: mentoring_session.id, id: mentorship_session2.id
      }

      it 'sets the status to accepted' do
        expect(mentorship_session2.accepted?).to eq true
      end

      it 'flashes a notice message' do
        expect(flash[:notice]).to eq "Session invitation accepted"
      end

      it 'redirects to previous page' do
        expect(response).to redirect_to "back"
      end
    end

    context 'without logged user' do
      before { get :accept, mentoring_session_id: mentoring_session.id, id: mentorship_session2.id }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end

  describe 'GET#decline' do

  end
end
