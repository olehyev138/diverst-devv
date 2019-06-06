require 'rails_helper'

RSpec.describe Groups::AttendancesController, type: :controller do
  let(:user) { create :user }
  let(:group) { create(:group, enterprise: user.enterprise) }
  let(:initiative) { initiative_of_group(group) }
  let!(:segment_1) { create(:segment, enterprise: user.enterprise) }

  describe 'GET#show' do
    context 'when user is logged in' do
      let!(:user1) { create(:user) }
      let!(:user2) { create(:user) }
      let!(:attendee1) { create(:initiative_user, initiative: initiative, user: user1) }
      let!(:attendee2) { create(:initiative_user, initiative: initiative, user: user2) }
      login_user_from_let
      before { get :show, group_id: group.id, event_id: initiative.id }

      it 'renders show tempate' do
        expect(response).to render_template :show
      end

      it 'sets a valid group object' do
        expect(assigns[:group]).to be_valid
      end

      it 'sets a valid event object' do
        expect(assigns[:event]).to be_valid
      end

      it 'return active attendees that belong to a particular event' do
        expect(assigns[:attendances].count).to eq 2
      end
    end

    context 'without logged user' do
      before { get :show, group_id: group.id, event_id: initiative.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'POST#create' do
    describe 'when user is logged in' do
      let(:attendee1) { create(:initiative_user, initiative: initiative, user: user) }
      login_user_from_let

      let!(:reward_action) { create(:reward_action, enterprise: user.enterprise, key: 'attend_event', points: 90) }

      it 'rewards a user with points of this action' do
        expect(user.points).to eq 0

        post :create, group_id: group.id, event_id: initiative.id

        user.reload
        expect(user.points).to eq 90
      end

      context 'if @attendance is set' do
        before do
          attendee1
          post :create, group_id: group.id, event_id: initiative.id
        end

        it 'response with status code of 204' do
          expect(response.status).to eq 204
        end
      end

      context 'if event is full' do
        let(:user2) { create(:user) }
        let(:outcome2) { create(:outcome, group: group) }
        let(:pillar2) { create(:pillar, outcome: outcome2) }
        let(:initiative2) { create(:initiative, owner_group_id: group.id, pillar: pillar2, max_attendees: 1) }

        before do
          post :create, group_id: group.id, event_id: initiative2.id, user_id: user.id

          post :create, group_id: group.id, event_id: initiative2.id, user_id: user2.id
        end

        it 'doesnt let users join' do
          expect(initiative2.attendees.count).to eq 1
        end
      end

      it 'creates an attendee' do
        expect { post :create, group_id: group.id, event_id: initiative.id }
        .to change(InitiativeUser, :count).by(1)
      end

      context 'returns a flash reward message' do
        before do
          user.enterprise.update(enable_rewards: true)
          post :create, group_id: group.id, event_id: initiative.id
        end

        it 'returns a flash reward message' do
          user.reload
          expect(flash[:reward]).to eq "Now you have #{ user.credits } points"
        end
      end

      it 'renders a partial' do
        post :create, group_id: group.id, event_id: initiative.id
        expect(response).to render_template('partials/flash_messages.js')
      end
    end

    describe 'without logged user' do
      before { post :create, group_id: group.id, event_id: initiative.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'DELETE#destroy' do
    context 'when user is logged in' do
      login_user_from_let

      let!(:reward_action) { create(:reward_action, enterprise: user.enterprise, key: 'attend_event', points: 90) }
      before do
        create(:initiative_user, initiative: initiative, user: user)
        Rewards::Points::Manager.new(user, reward_action.key).add_points(initiative)
      end

      it 'remove reward points of a user with points of this action' do
        expect(user.points).to eq 90

        delete :destroy, group_id: group.id, event_id: initiative.id

        user.reload
        expect(user.points).to eq 0
      end

      it 'deletes attendance' do
        expect { delete :destroy, group_id: group.id, event_id: initiative.id }
        .to change(InitiativeUser, :count).by(-1)
      end

      it 'returns response status as 204' do
        delete :destroy, group_id: group.id, event_id: initiative.id
        expect(response.status).to eq 204
      end
    end

    describe 'without logged user' do
      before { delete :destroy, group_id: group.id, event_id: initiative.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET#erg_graph' do
    context 'when user is logged in' do
      let!(:user1) { create(:user) }
      let!(:user2) { create(:user) }
      let!(:attendee1) { create(:initiative_user, initiative: initiative, user: user1) }
      let!(:attendee2) { create(:initiative_user, initiative: initiative, user: user2) }
      let!(:group1) { create(:group, enterprise: user.enterprise) }
      let!(:user_group1) { create(:user_group, group: group, user: user1) }
      let!(:user_group2) { create(:user_group, group: group1, user: user2) }
      login_user_from_let
      before { get :erg_graph, group_id: group.id, event_id: initiative.id }


      it 'gets the graph' do
        expect(response).to be_success
      end

      it 'render json' do
        expect(response.content_type).to eq 'application/json'
      end

      it 'returns data in json' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:series][0][:values].map { |data| data[:y] }).to eq [1, 1]
      end

      it "returns name of title as 'Number of attendees' in json" do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:title]).to eq 'Number of attendees'
      end

      it 'json data should include group names' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:series][0][:values].map { |data| data[:x] }).to eq assigns[:event].owner_group.enterprise.groups.map(&:name)
      end
    end

    context 'without logged user' do
      before { get :erg_graph, group_id: group.id, event_id: initiative.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#segment_graph' do
    context 'when user is logged in' do
      let!(:user1) { create(:user) }
      let!(:user2) { create(:user) }
      let!(:attendee1) { create(:initiative_user, initiative: initiative, user: user1) }
      let!(:attendee2) { create(:initiative_user, initiative: initiative, user: user2) }
      let!(:segments) { create_list(:segment, 2, enterprise: user.enterprise, owner: user) }
      let!(:users_segment1) { create(:users_segment, segment: segments.first, user: user1) }
      let!(:users_segment2) { create(:users_segment, segment: segments.last, user: user2) }
      login_user_from_let
      before { get :segment_graph, group_id: group.id, event_id: initiative.id }

      it 'returns response in json' do
        expect(response.content_type).to eq 'application/json'
      end

      it 'returns data in json' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:series][0][:values].map { |data| data[:y] }).to eq [0, 1, 1]
      end

      it "returns name of title as 'Number of attendees' in json" do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:title]).to eq 'Number of attendees'
      end

      it 'json data have categories to include segment names' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:series][0][:values].map { |data| data[:x] }).to eq assigns[:event].owner_group.enterprise.segments.map(&:name)
      end
    end

    context 'without logged user' do
      before { get :segment_graph, group_id: group.id, event_id: initiative.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
