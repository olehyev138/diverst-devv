require 'rails_helper'

RSpec.describe Groups::EventsController, type: :controller do
  let(:user) { create :user }
  let(:group) { create(:group, enterprise: user.enterprise) }
  let(:initiative) { initiative_of_group(group) }


  describe 'GET#index' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :index, group_id: group.id }

      it 'renders index template' do
        expect(response).to render_template :index
      end
    end

    context 'when user is not logged in' do
      before { get :index, group_id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET#calendar_data' do
    context 'when user is logged in' do
      login_user_from_let
      before do
        initiative
        get :calendar_data, group_id: group.id, format: :json
      end

      it 'returns json format' do
        expect(response.content_type).to eq 'application/json'
      end

      it 'return events' do
        expect(assigns[:events]).to eq [initiative]
      end

      it 'render shared/calendar/events' do
        expect(response).to render_template('shared/calendar/events')
      end
    end

    context 'when user is not logged in' do
      before { get :calendar_data, group_id: group.id, format: :json }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET#calendar_view' do
    context 'when user is logged in' do
      let!(:segments) { create_list(:segment, 2, enterprise: user.enterprise, owner: user) }
      login_user_from_let
      before { get :calendar_view, group_id: group.id }

      it 'renders the calendar_view' do
        expect(response).to render_template('groups/events/calendar_view')
      end

      it 'sets q_form_submit_path' do
        expect(assigns[:q_form_submit_path]).to eq calendar_view_group_events_path
      end

      it 'returns segments belonging to user.enterprise' do
        expect(assigns[:segments]).to eq segments
      end
    end

    context 'when user is not logged in' do
      before { get :calendar_view, group_id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET#show' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :show, group_id: group.id, id: initiative.id }
      let!(:comments) { create_list(:initiative_comment, 3, initiative: initiative, user: user) }

      it 'renders show template' do
        expect(response).to render_template :show
      end

      it 'sets a valid event object' do
        expect(assigns[:event]).to be_valid
      end

      it 'returns first comment belonging to a valid event object when such comments exists' do
        expect(assigns[:event].comments.where(user: user).first).to eq comments.first
      end

      it 'returns new comment belonging to valid event object' do
        expect(assigns[:comment].initiative).to eq initiative
        expect(assigns[:comment]).to be_a_new(InitiativeComment)
      end
    end

    context 'when user is not logged in' do
      before { get :show, group_id: group.id, id: initiative.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'DELETE#destroy' do
    context 'when user is logged in' do
      login_user_from_let
      before { delete :destroy, group_id: group.id, id: initiative.id }

      it 'redirect_to index' do
        expect(response).to redirect_to action: :index
      end

      it 'deletes the event' do
        expect(Initiative.where(id: initiative.id).count).to eq(0)
      end
    end

    context 'when user is not logged in' do
      before { delete :destroy, group_id: group.id, id: initiative.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET#export_ics' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :export_ics, group_id: group.id, id: initiative.id }

      it 'returns calendar format' do
        expect(response.headers['Content-Type']).to eq 'text/calendar'
      end

      it 'return parameterized title for event' do
        expect(response.headers['Content-Disposition']).to include initiative.title.parameterize + '.ics'
      end
    end

    context 'when user is not logged in' do
      before { get :export_ics, group_id: group.id, id: initiative.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
