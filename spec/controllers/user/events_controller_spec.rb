require 'rails_helper'

RSpec.describe User::EventsController, type: :controller do
  let(:user) { create :user }

  describe 'GET #index' do
    describe 'when user is logged in' do
      login_user_from_let

      it 'render index template' do
        get :index
        expect(response).to render_template :index
      end

      describe 'upcoming events' do
        let!(:initiative1) { create(:initiative, owner: user, start: Time.current + 5.days) }
        let!(:initiative2) { create(:initiative, owner: user, start: Time.current + 7.days) }
        let!(:initiative3) { create(:initiative, owner: user, start: Time.current) }
        let!(:invited_intiative1) { create(:initiative, owner: user, start: Time.current + 8.days) }
        let!(:invited_intiative2) { create(:initiative, owner: user, start: Time.current + 9.days) }
        let!(:invited_intiative3) { create(:initiative, owner: user, start: Time.current) }

        before { get :index }

        it 'return upcoming events' do
          user.initiatives << initiative1
          user.initiatives << initiative2
          user.initiatives << initiative3
          user.invited_initiatives << invited_intiative1
          user.invited_initiatives << invited_intiative2
          user.invited_initiatives << invited_intiative3

          upcoming_events = user.initiatives.upcoming + user.invited_initiatives.upcoming
          expect(assigns[:current_user].initiatives.upcoming.count + assigns[:current_user].invited_initiatives.upcoming.count).to eq upcoming_events.count
        end
      end

      describe 'past events' do
        let!(:initiative1) { create(:initiative, owner: user, start: Time.current - 5.days) }
        let!(:initiative2) { create(:initiative, owner: user, start: Time.current - 7.days) }
        let!(:initiative3) { create(:initiative, owner: user, start: Time.current + 1.days) }
        let!(:invited_intiative1) { create(:initiative, owner: user, start: Time.current - 8.days) }
        let!(:invited_intiative2) { create(:initiative, owner: user, start: Time.current - 9.days) }
        let!(:invited_intiative3) { create(:initiative, owner: user, start: Time.current + 1.days) }

        before { get :index }

        it 'returns past events' do
          user.initiatives << initiative1
          user.initiatives << initiative2
          user.initiatives << initiative3
          user.invited_initiatives << invited_intiative1
          user.invited_initiatives << invited_intiative2
          user.invited_initiatives << invited_intiative3

          past_events = user.initiatives.past + user.invited_initiatives.past
          expect(assigns[:current_user].initiatives.past.count + assigns[:current_user].invited_initiatives.past.count).to eq past_events.count
        end
      end

      describe 'ongoing events' do
        let!(:initiative1) { create(:initiative, owner: user, start: Time.current - 5.days, end: Time.current + 2.days) }
        let!(:initiative2) { create(:initiative, owner: user, start: Time.current - 7.days, end: Time.current + 3.days) }
        let!(:initiative3) { create(:initiative, owner: user, start: Time.current + 1.days, end: Time.current + 9.days) }
        let!(:invited_intiative1) { create(:initiative, owner: user, start: Time.current - 8.days, end: Time.current + 3.days) }
        let!(:invited_intiative2) { create(:initiative, owner: user, start: Time.current - 9.days, end: Time.current + 4.days) }
        let!(:invited_intiative3) { create(:initiative, owner: user, start: Time.current + 1.days, end: Time.current + 2.days) }

        before { get :index }

        it 'returns past events' do
          user.initiatives << initiative1
          user.initiatives << initiative2
          user.initiatives << initiative3
          user.invited_initiatives << invited_intiative1
          user.invited_initiatives << invited_intiative2
          user.invited_initiatives << invited_intiative3

          ongoing_events = user.initiatives.ongoing + user.invited_initiatives.ongoing
          expect(assigns[:current_user].initiatives.ongoing.count + assigns[:current_user].invited_initiatives.ongoing.count).to eq ongoing_events.count
        end
      end
    end

    describe 'when user is not logged in' do
      before { get :index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #calendar' do
    describe 'when user is logged in' do
      let!(:enterprise) { create(:enterprise) }
      let!(:user) { create(:user, enterprise: enterprise) }
      let!(:group) { create(:group, enterprise: enterprise, owner: user) }
      let!(:segment) { create(:segment, enterprise: enterprise) }
      login_user_from_let

      before {
        # create the sub groups to ensure only parent groups are shown
        group.children.create!([{ enterprise: enterprise, name: 'test1' }, { enterprise: enterprise, name: 'test2' }])
        get :calendar
      }

      it "returns current user's enterprise" do
        expect(assigns[:current_user].enterprise).to eq user.enterprise
      end

      it 'returns enterprise groups' do
        expect(assigns[:groups].count).to eq 1
      end

      it 'returns enterprise segments' do
        expect(assigns[:current_user].enterprise.segments).to eq [segment]
      end

      it 'return q_form_submit_path' do
        calendar_user_events_path = '/user/events/calendar'
        expect(assigns[:q_form_submit_path]).to eq calendar_user_events_path
      end

      it 'render calendar template' do
        expect(response).to render_template 'shared/calendar/calendar_view'
      end
    end

    describe 'when user is not logged in' do
      before { get :calendar }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #onboarding_calendar_data' do
    describe 'if user is present' do
      let!(:user) { create(:user) }

      before do
        user.invite!
        get :onboarding_calendar_data, invitation_token: user.raw_invitation_token, format: :json
      end

      it "render 'shared/calendar/events'" do
        expect(response).to render_template 'shared/calendar/events'
      end
    end

    describe 'if user is absent' do
      before { get :onboarding_calendar_data, invitation_token: '', format: :json }

      it 'redirects' do
        expect(response).to redirect_to user_root_path
      end
    end
  end
end
