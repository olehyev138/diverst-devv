require 'rails_helper'

RSpec.describe MentoringsController, type: :controller do
  let(:user) { create :user }
  let(:mentor) { create :user }

  describe 'GET #index' do
    describe 'if user is present' do
      login_user_from_let

      it 'assigns the mentors' do
        get :index, mentor: true, format: :json
        expect(assigns[:users]).to eq([])
      end

      it 'assigns the mentees' do
        get :index, mentee: true, format: :json
        expect(assigns[:users]).to eq([])
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'if user is present' do
      login_user_from_let
      before {
        request.env['HTTP_REFERER'] = 'back'
      }

      it 'destroys the mentorship' do
        mentoring = create(:mentoring, mentor_id: mentor.id, mentee_id: user.id)
        delete :destroy, id: mentoring.id

        expect { Mentoring.find(mentoring.id) }.to raise_error ActiveRecord::RecordNotFound
      end

      it 'redirects back' do
        mentoring = create(:mentoring, mentor_id: mentor.id, mentee_id: user.id)
        delete :destroy, id: mentoring.id

        expect(response).to redirect_to 'back'
      end
    end
  end
end
