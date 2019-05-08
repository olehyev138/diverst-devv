require 'rails_helper'

RSpec.describe MentoringSessionsController, type: :controller do
  let(:user) { create :user }
  let(:mentor) { create :user }

  describe 'GET #new' do
    describe 'if user is present' do
      login_user_from_let

      it 'assigns the mentoring_session' do
        get :new
        expect(assigns[:mentoring_session].status).to eq('scheduled')
      end

      it 'renders the template' do
        get :new
        expect(response).to render_template('user/mentorship/sessions/new')
      end
    end
  end

  describe 'GET #edit' do
    describe 'if user is present' do
      login_user_from_let
      it 'renders the template' do
        mentoring_session = create(:mentoring_session, creator: user)
        mentoring_session.mentorship_sessions.create(user: user, mentoring_session: mentoring_session, role: 'presenter')

        get :edit, id: mentoring_session.id
        expect(response).to render_template('user/mentorship/sessions/edit')
      end
    end
  end

  describe 'GET #show' do
    describe 'if user is present' do
      login_user_from_let
      it 'renders the template' do
        mentoring_session = create(:mentoring_session)
        mentoring_session.mentorship_sessions.create(user: user, mentoring_session: mentoring_session, role: 'presenter')

        get :show, id: mentoring_session.id
        expect(response).to render_template('user/mentorship/sessions/show')
      end
    end
  end

  context 'when using twilio gem' do
    before {
      ENV['TWILIO_ACCOUNT_SID'] = 'TEST'
      ENV['TWILIO_API_KEY'] = 'TEST'
      ENV['TWILIO_SECRET'] = 'TEST'
      token = double('Twilio::JWT::AccessToken', add_grant: {}, to_jwt: true)

      allow(Twilio::JWT::AccessToken).to receive(:new).and_return(token)
      allow(Twilio::JWT::AccessToken::VideoGrant).to receive(:new).and_return(OpenStruct.new({ room: true }))
    }

    describe 'GET #start' do
      describe 'if user is present' do
        login_user_from_let
        it 'renders the template' do
          mentoring_session = create(:mentoring_session, creator: user)
          mentoring_session.mentorship_sessions.create(user: user, mentoring_session: mentoring_session, role: 'presenter')

          get :start, id: mentoring_session.id
          expect(response).to render_template('user/mentorship/sessions/start')
        end
      end
    end

    describe 'GET #join' do
      describe 'if user is present' do
        login_user_from_let
        it 'renders the template' do
          mentoring_session = create(:mentoring_session, creator: user)
          mentoring_session.mentorship_sessions.create(user: user, mentoring_session: mentoring_session, role: 'presenter')

          get :join, id: mentoring_session.id
          expect(response).to render_template('user/mentorship/sessions/start')
        end
      end
    end
  end

  describe 'PUT #update' do
    describe 'if user is present' do
      let(:mentoring_session) { create(:mentoring_session, mentorship_sessions_attributes: [{ user_id: user.id, role: 'presenter' }]) }
      login_user_from_let

      it 'updates the request' do
        put :update, id: mentoring_session.id, mentoring_session: { format: 'Webex' }
        mentoring_session.reload
        expect(mentoring_session.format).to eq('Webex')
      end

      it 'renders edit' do
        allow_any_instance_of(MentoringSession).to receive(:update).and_return(false)
        put :update, id: mentoring_session.id, mentoring_session: { start: Date.today, end: Date.tomorrow + 1.day, notes: 'Please mentor me!', format: 'Webex' }
        expect(response).to redirect_to action: :edit
      end
    end
  end

  describe 'POST #create' do
    describe 'if user is present' do
      login_user_from_let

      it 'creates the request' do
        post :create, mentoring_session: { start: Date.today, end: Date.tomorrow + 1.day, notes: 'Please mentor me!', format: 'Webex' }
        expect(MentoringSession.count).to eq(1)
      end

      it 'flashes' do
        allow_any_instance_of(MentoringSession).to receive(:save).and_return(false)
        post :create, mentoring_session: { start: Date.today, end: Date.tomorrow, notes: 'Please mentor me!', format: 'Webex' }
        expect(flash[:alert]).to eq('Your session was not scheduled')
      end
    end
  end

  describe 'POST #create_comment' do
    describe 'when user is logged in' do
      before {
        request.env['HTTP_REFERER'] = 'back'
      }
      login_user_from_let

      let!(:mentoring_session) { create(:mentoring_session, creator: user, mentorship_sessions_attributes: [{ user_id: user.id, role: 'presenter' }]) }

      context 'with valid attributes' do
        it 'creates and saves a comment object' do
          expect { post :create_comment, mentoring_session_id: mentoring_session.id, mentoring_session_comment: attributes_for(:mentoring_session_comment) }
          .to change(MentoringSessionComment, :count).by(1)
        end

        it 'flashes a notice message' do
          post :create_comment, mentoring_session_id: mentoring_session.id, mentoring_session_comment: attributes_for(:mentoring_session_comment)
          expect(flash[:notice]).to eq 'Your comment was created'
        end

        it 'redirect back' do
          post :create_comment, mentoring_session_id: mentoring_session.id, mentoring_session_comment: attributes_for(:mentoring_session_comment)
          expect(response).to redirect_to 'back'
        end
      end

      context 'with invalid attributes' do
        invalid_attributes = FactoryBot.attributes_for(:mentoring_session_comment)
        let!(:invalid_attributes) { invalid_attributes[:content] = nil }

        it 'flashes an alert message' do
          post :create_comment, mentoring_session_id: mentoring_session.id, mentoring_session_comment: invalid_attributes
          expect(flash[:alert]).to eq 'Comment not saved. Please fix the errors'
        end

        it 'redirect to group_group_message_path' do
          post :create_comment, mentoring_session_id: mentoring_session.id, mentoring_session_comment: invalid_attributes
          expect(response).to redirect_to 'back'
        end
      end
    end

    describe 'when user is not logged in' do
      before { post :create_comment, mentoring_session_id: mentoring_session.id, mentoring_session_comment: attributes_for(:mentoring_session_comment) }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #export_ics' do
    describe 'if user is present' do
      login_user_from_let
      it 'renders the template' do
        mentoring_session = create(:mentoring_session)
        mentoring_session.mentorship_sessions.create(user: user, mentoring_session: mentoring_session, role: 'presenter')

        get :export_ics, id: mentoring_session.id
        expect(response.headers['Content-Type']).to eq 'text/calendar'
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
        mentoring_session = create(:mentoring_session, creator: user)
        mentoring_session.mentorship_sessions.create(user: user, mentoring_session: mentoring_session, role: 'presenter', status: 'pending')

        delete :destroy, id: mentoring_session.id
        expect { MentoringSession.find(mentoring_session.id) }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
