require 'rails_helper'

RSpec.describe MentorshipSessionsController, type: :controller do
  let(:enterprise) { create :enterprise }
  let(:user){ create(:user, enterprise: enterprise) }
  let(:creator) { create(:user, enterprise: enterprise) }
  let(:mentoring_session){ create(:mentoring_session, enterprise: enterprise, creator: creator, start: Date.today, end: Date.tomorrow + 1.day, status: "scheduled", format: "Video") }
  let!(:mentorship_session){ mentoring_session.mentorship_sessions.create(:user => creator, :mentoring_session => mentoring_session, :role => "presenter") }
  let!(:mentorship_session2){ mentoring_session.mentorship_sessions.create(:user => user, :mentoring_session => mentoring_session, :role => "viewer") }

  describe 'POST#accept' do
    login_user_from_let

    before {
      request.env["HTTP_REFERER"] = "back"
      post :accept, mentoring_session_id: mentoring_session.id, id: mentorship_session2.id
    }

    context 'when user is logged in' do
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
      it_behaves_like "redirect user to users/sign_in path"
    end
  end

  describe 'POST#decline' do
    login_user_from_let

    before {
      request.env["HTTP_REFERER"] = "back"
      post :decline, mentoring_session_id: mentoring_session.id, id: mentorship_session2.id
    }

    context 'when user is logged in' do
      it 'sets the status to declined' do
        expect(mentorship_session2.declined?).to eq true
      end

      it 'flashes a notice message' do
        expect(flash[:notice]).to eq "Session invitation declined"
      end

      it 'redirects to previous page' do
        expect(response).to redirect_to "back"
      end
    end

    context 'without logged user' do
      it_behaves_like "redirect user to users/sign_in path"
    end
  end
end
