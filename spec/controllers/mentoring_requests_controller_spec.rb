require 'rails_helper'

RSpec.describe MentoringRequestsController, type: :controller do
  let(:user) { create :user }
  let(:mentor) { create :user }

  describe 'GET #new' do
    describe 'if user is present' do
      login_user_from_let

      it 'assigns the sender_id and receiver_id' do
        get :new, sender_id: 1, receiver_id: 2
        expect(assigns[:mentoring_request].sender_id).to eq(1)
      end

      it 'renders the mentor template' do
        get :new, sender_id: 1, receiver_id: 2, mentoring_type: 'mentor'
        expect(response).to render_template('user/mentorship/mentors/new')
      end

      it 'renders the mentee template' do
        get :new, sender_id: 1, receiver_id: 2, mentoring_type: 'mentee'
        expect(response).to render_template('user/mentorship/mentees/new')
      end
    end
  end

  describe 'POST #create' do
    describe 'if user is present' do
      login_user_from_let

      it 'creates the request' do
        post :create, mentoring_request: { sender_id: user.id, receiver_id: mentor.id, notes: 'Please mentor me!' }
        expect(MentoringRequest.count).to eq(1)
      end

      it 'flashes' do
        allow_any_instance_of(MentoringRequest).to receive(:save).and_return(false)
        post :create, mentoring_request: { sender_id: user.id, receiver_id: mentor.id, notes: 'Please mentor me!' }
        expect(flash[:alert]).to eq(nil)
        expect(response).to render_template 'user/mentorship/mentors/new'
      end
    end
  end

  describe 'PUT #update' do
    describe 'if user is present' do
      login_user_from_let
      before {
        request.env['HTTP_REFERER'] = 'back'
      }

      it 'creates the request for the user as the mentor' do
        mentoring_request = create(:mentoring_request, mentoring_type: 'mentor', sender: user, receiver: mentor, enterprise: user.enterprise)
        patch :update, id: mentoring_request.id
        expect(flash[:notice]).to eq('Your request has been accepted')
      end

      it 'creates the request for the user as the mentee' do
        mentoring_request = create(:mentoring_request, mentoring_type: 'mentee', sender: mentor, receiver: user, enterprise: user.enterprise)
        patch :update, id: mentoring_request.id
        expect(flash[:notice]).to eq('Your request has been accepted')
      end

      it 'redirects back' do
        mentoring_request = create(:mentoring_request, sender: user, receiver: mentor, enterprise: user.enterprise)
        patch :update, id: mentoring_request.id
        expect(response).to redirect_to 'back'
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'if user is present' do
      login_user_from_let
      before {
        request.env['HTTP_REFERER'] = 'back'
      }

      it 'destroys the request' do
        mentoring_request = create(:mentoring_request, status: 'accepted', sender: user, receiver: mentor, enterprise: user.enterprise)
        delete :destroy, id: mentoring_request.id
        expect { MentoringRequest.find(mentoring_request.id) }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
