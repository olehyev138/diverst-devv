require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise, email: 'test@gmail.com') }

  let!(:group) { create(:group, enterprise: enterprise, position: 0, auto_archive: false, upcoming_events_visibility: 'public') }

  let!(:different_group) { create(:group, enterprise: create(:enterprise)) }

  describe 'GET #index' do
    context 'with logged user' do
      login_user_from_let

      it 'render template' do
        get :index
        expect(response).to render_template :index
      end

      it 'correctly sets groups' do
        get :index
        expect(group.enterprise).to eq enterprise
      end

      context 'display groups belonging to current user enterprise' do
        before { group; different_group }

        it 'returns 1 group' do
          get :index
          expect(assigns[:groups].count).to eq 1
        end
      end

      context 'where groups have children' do
        let!(:parent_groups) { create_list(:group, 2, enterprise: enterprise) }
        let!(:child_group) { create(:group, enterprise: enterprise) }
        before do
          group
          parent_groups.each { |parent| parent.children << child_group }
        end

        it 'total number of groups should be 4' do
          get :index
          expect(Group.by_enterprise(enterprise.id).count).to eq 4
        end

        it 'returns 4 groups' do
          get :index
          expect(assigns[:groups].count).to eq 4
        end
      end
    end

    context 'without logged user' do
      before { get :index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #get_all_groups' do
    context 'with logged user' do
      let!(:group2) { create(:group, enterprise: enterprise, position: 1) }

      login_user_from_let

      before { get :get_all_groups, format: :json }

      it 'returns all groups' do
        expect(assigns[:groups]).to match_array([group, group2])
      end

      it 'returns in the proper json format' do
        parsed_body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expect(parsed_body.find { |i| i['id'] == group.id }).not_to eq(nil)
        expect(parsed_body.find { |i| i['text'] == group.name }).not_to eq(nil)
        expect(parsed_body.find { |i| i['id'] == group2.id }).not_to eq(nil)
        expect(parsed_body.find { |i| i['text'] == group2.name }).not_to eq(nil)
      end
    end

    context 'without logged user' do
      before { get :get_all_groups, format: :json }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #close_budgets' do
    context 'with logged user' do
      login_user_from_let

      context 'with correct permissions' do
        it 'render close_budgets template' do
          get :close_budgets, id: group.id
          expect(response).to render_template :close_budgets
        end

        context 'where groups have children' do
          let!(:parent_groups) { create_list(:group, 2, enterprise: enterprise) }
          let!(:child_group) { create(:group, enterprise: enterprise) }
          before do
            group
            parent_groups.each { |parent| parent.children << child_group }
          end

          it 'total number of groups should be 4' do
            get :close_budgets, id: group.id
            expect(Group.by_enterprise(enterprise.id).count).to eq 4
          end

          it 'return 3 groups' do
            get :close_budgets, id: group.id
            expect(assigns[:groups].count).to eq 3
          end
        end

        context 'display groups belonging to current user enterprise' do
          before { group; different_group }

          it 'returns 1 group' do
            get :close_budgets, id: group.id
            expect(assigns[:groups].count).to eq 1
          end
        end
      end

      context 'with incorrect permissions' do
        it 'render close_budgets template' do
          policy_group = user.policy_group
          policy_group.manage_all = false
          policy_group.groups_budgets_manage = false
          policy_group.save!

          get :close_budgets, id: group.id
          expect(response).to_not render_template :close_budgets
        end
      end
    end

    context 'without logged user' do
      before { get :close_budgets, id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#close_budgets_export_csv' do
    context 'when user is logged in' do
      login_user_from_let
      before {
        allow(GroupsCloseBudgetsDownloadJob).to receive(:perform_later)
        request.env['HTTP_REFERER'] = 'back'
        get :close_budgets_export_csv
      }

      it 'returns to previous page' do
        expect(response).to redirect_to 'back'
      end

      it 'flashes' do
        expect(flash[:notice]).to eq 'Please check your Secure Downloads section in a couple of minutes'
      end

      it 'calls job' do
        expect(GroupsCloseBudgetsDownloadJob).to have_received(:perform_later)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { get :close_budgets_export_csv }.to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { enterprise }
          let(:owner) { user }
          let(:key) { 'enterprise.export_close_budgets' }

          before {
            perform_enqueued_jobs do
              get :close_budgets_export_csv
            end
          }

          include_examples 'correct public activity'
        end
      end
    end

    context 'when user is not logged in' do
      before { get :close_budgets_export_csv }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#plan_overview' do
    let!(:user) { create :user }
    let!(:group) { create(:group, enterprise: user.enterprise) }

    context 'with logged user' do
      login_user_from_let

      before { get :plan_overview, id: group.id }

      it 'render plan_overview template' do
        expect(response).to render_template :plan_overview
      end

      it 'shows groups from correct enterprise' do
        expect(assigns(:group)).to eq group
      end
    end

    context 'without logged user' do
      before { get :plan_overview }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #calendar' do
    context 'with logged user' do
      login_user_from_let

      before do
        create_list(:group, 2, enterprise: enterprise)
        # create the sub groups to ensure only parent groups are shown
        group.children.create!([{ enterprise: enterprise, name: 'test1' }, { enterprise: enterprise, name: 'test2' }])
        create_list(:segment, 3, enterprise: enterprise)
        get :calendar
      end
      it "render 'shared/calendar/calendar_view" do
        expect(response).to render_template('shared/calendar/calendar_view')
      end

      it 'returns 2 groups belonging to enterprise' do
        expect(assigns[:groups].count).to eq 5
      end

      it 'returns 3 segments belonging to enterprise' do
        expect(assigns[:segments].count).to eq 3
      end

      it 'returns q_form_submit_path as calendar_groups_path' do
        expect(assigns[:q_form_submit_path]).to eq calendar_groups_path
      end
    end

    context 'without logged user' do
      before { get :calendar }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #calendar_data' do
    def get_calendar_data(initiative_participating_groups_id_in, initiative_segments_segement_id_in, params = {})
      get :calendar_data, params,
          q: { initiative_participating_groups_group_id_in: initiative_participating_groups_id_in,
               initiative_segments_segement_id_in: initiative_segments_segement_id_in }, format: :json
    end

    let(:initiative) { create :initiative }
    let(:group) { create :group, enterprise_id: enterprise.id }
    let(:event) { create :event, group_id: group.id }
    let(:initiative_group) { create :initiative_group, group_id: group.id, initiative_id: initiative.id }
    let(:initiative_segment) { create :initiative_segment, initiative_id: initiative.id }


    context 'with logged in user' do
      context 'when params[:token] is present' do
        let!(:enterprise) { create :enterprise, iframe_calendar_token: 'uniquetoken1234' }
        let!(:enterprise1) { create :enterprise }
        let!(:user) { create :user, enterprise: enterprise }
        login_user_from_let

        it 'returns enterprise via iframe_calendar_token' do
          get_calendar_data(initiative_group.id, initiative_segment.id, params = { token: 'uniquetoken1234' })
          expect(Enterprise.find_by_iframe_calendar_token(controller.params[:token])).to eq enterprise
        end
      end

      context 'when params[:token] is absent' do
        let!(:enterprise) { create :enterprise, iframe_calendar_token: 'uniquetoken1234' }
        let!(:enterprise1) { create :enterprise }
        let!(:user) { create :user, enterprise: enterprise1 }
        login_user_from_let

        it 'returns enterprise of current_user' do
          get_calendar_data(initiative_group.id, initiative_segment.id)
          expect(assigns[:current_user]&.enterprise).to eq enterprise1
        end
      end

      context 'renders' do
        let!(:enterprise) { create :enterprise, iframe_calendar_token: 'uniquetoken1234' }
        let!(:user) { create :user, enterprise: enterprise }
        login_user_from_let

        it 'shared/calendar/events' do
          get_calendar_data(initiative_group.id, initiative_segment.id, params = {})
          expect(response).to render_template 'shared/calendar/events'
        end
      end
    end

    context 'without logged in user' do
      context 'with incorrect token code' do
        let!(:enterprise) { create :enterprise, iframe_calendar_token: 'uniquetoken1234' }

        it 'returns error' do
          get_calendar_data(initiative_group.id, initiative_segment.id, params = { token: 'incorrect token' })
          expect(response.status).to eq 200
        end
      end

      context 'without token code' do
        it 'should raise Pundit::NotAuthorizedError' do
          get_calendar_data(initiative_group.id, initiative_segment.id)
          expect(response.status).to eq 200
        end
      end
    end
  end

  describe 'GET #new' do
    context 'with logged user' do
      login_user_from_let

      before { get :new }

      it 'render new template' do
        expect(response).to render_template :new
      end

      it "returns a new group object that belongs to current_user's enterprise" do
        expect(assigns[:group].enterprise).to eq assigns[:current_user].enterprise
        expect(assigns[:group]).to be_a_new(Group)
      end
    end

    context 'without logged user' do
      before { get :new }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #show' do
    context 'with logged user' do
      login_user_from_let
      before { get :show, id: group.id }

      it 'render show template' do
        expect(response).to render_template :show
      end

      describe 'members list' do
        let(:group) { create(:group, enterprise: enterprise, pending_users: 'enabled') }

        let(:active_user) { create :user, enterprise: group.enterprise }
        let(:inactive_user) { create :user, enterprise: group.enterprise, active: false }
        let(:pending_user) { create :user, enterprise: group.enterprise }

        let!(:active_user_user_group) {
          create :user_group,
                 user: active_user,
                 group: group,
                 accepted_member: true
        }

        let!(:inactive_user_user_group) {
          create :user_group,
                 user: inactive_user,
                 group: group,
                 accepted_member: true
        }

        let!(:pending_user_user_group) {
          create :user_group,
                 user: pending_user,
                 group: group,
                 accepted_member: false
        }


        before { get :show, id: group.id }

        it 'shows active users' do
          expect(assigns[:members]).to include active_user
        end

        it 'does not show pending users' do
          expect(assigns[:members]).to_not include pending_user
        end

        it 'does not show inactive users' do
          expect(assigns[:members]).to_not include inactive_user
        end
      end
    end

    context 'with logged regular user group member' do
      let(:user) { create(:user, enterprise: enterprise) }
      let!(:user_group) { create(:user_group, group: group, user: user, accepted_member: true) }

      login_user_from_let
      before { get :show, id: group.id }

      it 'render show template' do
        expect(response).to render_template :show
      end

      context 'when group has erg_leader_permissions' do
        let!(:group_leader) { create(:group_leader, user: user, group: group) }
        let!(:news_feed) { group.news_feed }
        let!(:news_link1) { create(:news_link, group: group) }
        let!(:news_link2) { create(:news_link, group: group) }
        let!(:news_link3) { create(:news_link, group: group) }
        let!(:news_link4) { create(:news_link, group: group) }
        let!(:news_link5) { create(:news_link, group: group) }
        let!(:news_link6) { create(:news_link, group: group) }
        let!(:news_feed_link1) { create(:news_feed_link, news_link: news_link1, news_feed: news_feed, approved: true, created_at: Time.now - 5.hours, updated_at: Time.now - 5.hours) }
        let!(:news_feed_link2) { create(:news_feed_link, news_link: news_link2, news_feed: news_feed, approved: true, created_at: Time.now - 4.hours, updated_at: Time.now - 4.hours) }
        let!(:news_feed_link3) { create(:news_feed_link, news_link: news_link3, news_feed: news_feed, approved: true, created_at: Time.now - 3.hours, updated_at: Time.now - 3.hours) }
        let!(:news_feed_link4) { create(:news_feed_link, news_link: news_link4, news_feed: news_feed, approved: true, created_at: Time.now - 2.hours, updated_at: Time.now - 2.hours) }
        let!(:news_feed_link5) { create(:news_feed_link, news_link: news_link5, news_feed: news_feed, approved: true, created_at: Time.now - 1.hours, updated_at: Time.now - 1.hours) }
        let!(:news_feed_link6) { create(:news_feed_link, news_link: news_link6, news_feed: news_feed, approved: true, created_at: Time.now, updated_at: Time.now) }

        login_user_from_let
        before { get :show, id: group.id }

        it 'returns limited 5 posts' do
          expect(assigns[:posts].count).to eq 5
        end

        describe 'when current user is not a leader' do
          let!(:group_leader) { nil }
          let!(:segment) { create(:segment, enterprise: user.enterprise, owner: user) }
          let!(:users_segment) { create(:users_segment, user: user, segment: segment) }
          let!(:news_link_segment) { create(:news_link_segment, segment: segment, news_link: news_link1) }
          let!(:news_feed_link_segment) { create(:news_feed_link_segment, segment: segment, news_feed_link: news_feed_link1, news_link_segment: news_link_segment) }
          let!(:other_user) { create(:user) }
          let!(:other_group) { create(:group, enterprise: other_user.enterprise, owner: other_user) }

          context 'when current_user is an active member of group' do
            login_user_from_let
            before { get :show, id: group.id }

            it 'returns posts limited to 5 belonging to group' do
              expect(assigns[:posts].count).to eq 5
            end
          end

          context 'when current_user is not an active member of group' do
            let!(:user) { other_user }
            login_user_from_let
            before { get :show, id: other_group.id }

            it 'returns an empty array for posts' do
              expect(assigns[:posts]).to eq []
            end
          end
        end
      end
    end

    context 'with logged regular user non-group member' do
      let(:user) { create(:user, enterprise: enterprise) }

      login_user_from_let

      before { get :show, id: group.id }

      it 'render show template' do
        expect(response).to render_template :show
      end
    end

    context 'without logged user' do
      before { get :show, id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end

    describe 'viewing upcoming events' do
      let!(:group_event_non_member) { create(:group, enterprise: enterprise, position: 0, auto_archive: false, upcoming_events_visibility: 'non_member') }
      let!(:group_event_group) { create(:group, enterprise: enterprise, position: 0, auto_archive: false, upcoming_events_visibility: 'group') }
      let!(:group_event_leaders_only) { create(:group, enterprise: enterprise, position: 0, auto_archive: false, upcoming_events_visibility: 'leaders_only') }

      context 'user is not a member' do
        let(:user) { create(:user, enterprise: enterprise) }
        login_user_from_let

        describe 'events can be viewed by public' do
          before { get :show, id: group.id }
          it 'should let users see upcoming events' do
            expect(assigns[:show_events]).to eq true
          end
        end
        describe 'events can be viewed by non_members' do
          before { get :show, id: group_event_non_member.id }
          it 'should let users see upcoming events' do
            expect(assigns[:show_events]).to eq true
          end
        end
        describe 'events can be viewed by group' do
          before { get :show, id: group_event_group.id }
          it 'should not let users see upcoming events' do
            expect(assigns[:show_events]).to eq false
          end
        end
        describe 'events can be viewed by leaders only' do
          before { get :show, id: group_event_leaders_only.id }
          it 'should not let users see upcoming events' do
            expect(assigns[:show_events]).to eq false
          end
        end

        context 'user is a member' do
          let!(:user_group) { create(:user_group, group: group, user: user, accepted_member: true) }
          let!(:user_group_non_member) { create(:user_group, group: group_event_non_member, user: user, accepted_member: true) }
          let!(:user_group_group) { create(:user_group, group: group_event_group, user: user, accepted_member: true) }
          let!(:user_group_leaders) { create(:user_group, group: group_event_leaders_only, user: user, accepted_member: true) }

          describe 'events can be viewed by public' do
            before { get :show, id: group.id }
            it 'should let users see upcoming events' do
              expect(assigns[:show_events]).to eq true
            end
          end
          describe 'events can be viewed by non_members' do
            before { get :show, id: group_event_non_member.id }
            it 'should let users see upcoming events' do
              expect(assigns[:show_events]).to eq true
            end
          end
          describe 'events can be viewed by group' do
            before { get :show, id: group_event_group.id }
            it 'should let users see upcoming events' do
              expect(assigns[:show_events]).to eq true
            end
          end
          describe 'events can be viewed by leaders only' do
            before { get :show, id: group_event_leaders_only.id }
            it 'should not let users see upcoming events' do
              expect(assigns[:show_events]).to eq false
            end
          end


          context 'user is a leader' do
            let!(:group_leader) { create(:group_leader, user: user, group: group) }
            let!(:group_leader_non_member) { create(:group_leader, user: user, group: group_event_non_member) }
            let!(:group_leader_group) { create(:group_leader, user: user, group: group_event_group) }
            let!(:group_leader_leaders) { create(:group_leader, user: user, group: group_event_leaders_only) }

            describe 'events can be viewed by public' do
              before { get :show, id: group.id }
              it 'should let users see upcoming events' do
                expect(assigns[:show_events]).to eq true
              end
            end
            describe 'events can be viewed by non_members' do
              before { get :show, id: group_event_non_member.id }
              it 'should let users see upcoming events' do
                expect(assigns[:show_events]).to eq true
              end
            end
            describe 'events can be viewed by group' do
              before { get :show, id: group_event_group.id }
              it 'should let users see upcoming events' do
                expect(assigns[:show_events]).to eq true
              end
            end
            describe 'events can be viewed by leaders only' do
              before { get :show, id: group_event_leaders_only.id }
              it 'should let users see upcoming events' do
                expect(assigns[:show_events]).to eq true
              end
            end
          end
        end
      end
    end
  end

  describe 'POST #create' do
    def post_create(params = { a: 1 })
      post :create, group: params
    end

    describe 'with logged in user' do
      let(:user) { create :user }
      let(:group_attrs) { attributes_for :group }

      login_user_from_let

      context 'with correct params' do
        it 'creates group' do
          expect {
            post_create(group_attrs)
          }.to change(Group, :count).by(1)
        end

        it 'flashes a notice message' do
          post_create(group_attrs)
          expect(flash[:notice]).to eq "Your #{c_t(:erg)} was created"
        end

        it 'creates correct group' do
          post_create(group_attrs)

          new_group = Group.last

          expect(new_group.enterprise).to eq user.enterprise
          expect(new_group.name).to eq group_attrs[:name]
          expect(new_group.created_at).to be_within(100).of Time.now.in_time_zone
          expect(new_group.owner).to eq user
        end

        it 'redirects to correct action' do
          post_create(group_attrs)
          expect(response).to redirect_to action: :index
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect {
                post_create(group_attrs)
              }.to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { Group.last }
            let(:owner) { user }
            let(:key) { 'group.create' }

            before {
              perform_enqueued_jobs do
                post_create(group_attrs)
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'with incorrect params' do
        it 'does not save the new group' do
          expect { post_create() }
            .to_not change(Group, :count)
        end

        it 'flashes an alert message' do
          post_create
          expect(flash[:alert]).to eq "Your #{c_t(:erg)} was not created. Please fix the errors"
        end

        it 'renders new view' do
          post_create
          expect(response).to render_template :new
        end

        it 'shows error' do
          post_create
          group = assigns(:group)

          expect(group.errors).to_not be_empty
        end
      end
    end

    describe 'without logged in user' do
      before { post_create }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #edit' do
    context 'with logged user' do
      login_user_from_let
      before { get :edit, id: group.id }

      it 'render edit template' do
        expect(response).to render_template :edit
      end

      it 'assigns a valid group object' do
        expect(assigns[:group]).to be_valid
      end
    end

    context 'without logged user' do
      before { get :edit, id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH #update' do
    def patch_update(group_id = -1, params = {})
      patch :update, id: group_id, group: params
    end

    let(:user) { create :user }
    let!(:group) { create :group, enterprise: user.enterprise }

    before { request.env['HTTP_REFERER'] = 'back' }

    describe 'with logged in user' do
      login_user_from_let

      context 'with correct params' do
        let(:group_attrs) { attributes_for :group }

        it 'updates fields' do
          patch_update(group.id, group_attrs)

          updated_group = Group.find(group.id)

          expect(updated_group.name).to eq group_attrs[:name]
          expect(updated_group.description).to eq group_attrs[:description]
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect {
                patch_update(group.id, group_attrs)
              }.to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { group }
            let(:owner) { user }
            let(:key) { 'group.update' }

            before {
              perform_enqueued_jobs do
                patch_update(group.id, group_attrs)
              end
            }

            include_examples 'correct public activity'
          end
        end

        it 'flashes a notice message' do
          patch_update(group.id, group_attrs)
          expect(flash[:notice]).to eq "Your #{c_t(:erg)} was updated"
        end

        it 'redirects to correct page' do
          patch_update(group.id, group_attrs)

          expect(response).to redirect_to 'back'
        end
      end

      context 'with incorrect params' do
        before { patch_update(group.id, { name: '' }) }

        it 'does not update group' do
          updated_group = Group.find(group.id)

          expect(updated_group.name).to eq group.name
          expect(updated_group.description).to eq group.description
        end

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq "Your #{c_t(:erg)} was not updated. Please fix the errors"
        end

        it 'renders settings template' do
          expect(response).to render_template :settings
        end
      end
    end

    describe 'with label of different category type' do
      login_user_from_let
      let!(:group_category_type) { create(:group_category_type, name: 'category type 1', enterprise_id: user.enterprise.id) }
      let!(:group_category_type2) { create(:group_category_type, name: 'category type 2', enterprise_id: user.enterprise.id) }
      let!(:group_category1) { create(:group_category, name: 'category 1', enterprise_id: user.enterprise.id, group_category_type_id: group_category_type.id) }
      let!(:group_category2) { create(:group_category, name: 'category 2', enterprise_id: user.enterprise.id, group_category_type_id: group_category_type2.id) }
      let!(:parent) { create(:group, enterprise: user.enterprise, parent_id: nil, group_category_type_id: group_category_type.id, group_category_id: nil) }
      let!(:group1) { create(:group, enterprise: user.enterprise, parent: parent, group_category_id: group_category1.id,
                                     group_category_type_id: parent.group_category_type_id)
      }

      before do
        request.env['HTTP_REFERER'] = "http://test.host/groups/#{group1.id}"
        patch_update(group1.id, { group_category_id: group_category2.id })
      end

      it "contains error message'wrong label for category type 1'" do
        expect(assigns[:group].errors.full_messages).to include 'Group category wrong label for category type 1'
      end

      it 'renders edit template' do
        expect(response).to render_template :edit
      end
    end

    describe 'without logged in user' do
      before { patch_update(group.id) }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #settings' do
    let(:user) { create :user }
    let(:group) { create :group, enterprise: user.enterprise }

    def get_settings(group_id = -1)
      get :settings, id: group_id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_settings(group.id) }

      it 'assigns a valid group object' do
        expect(assigns[:group]).to be_valid
      end

      it 'renders setting template' do
        expect(response).to render_template :settings
      end
    end

    context 'without logged user' do
      before { get_settings }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'DELETE #destroy' do
    def delete_destroy(group_id = -1)
      request.env['HTTP_REFERER'] = 'back'
      delete :destroy, id: group_id
    end

    let(:user) { create :user }
    let!(:group) { create :group, enterprise: user.enterprise }

    context 'with logged in user' do
      login_user_from_let

      context 'with correct params' do
        it 'deletes group' do
          expect {
            delete_destroy(group.id)
          }.to change(Group, :count).by(-1)
        end

        it 'flashes a notice message' do
          delete_destroy(group.id)
          expect(flash[:notice]).to eq "Your #{c_t(:erg)} was deleted"
        end

        it 'redirects to correct action' do
          delete_destroy(group.id)
          expect(response).to redirect_to action: :index
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect {
                delete_destroy(group.id)
              }.to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { group }
            let(:owner) { user }
            let(:key) { 'group.destroy' }

            before {
              perform_enqueued_jobs do
                delete_destroy(group.id)
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'when not saving' do
        before { allow_any_instance_of(Group).to receive(:destroy).and_return(false) }

        it 'flashes an alert message' do
          delete_destroy(group.id)
          expect(flash[:alert]).to eq "Your #{c_t(:erg)} was not deleted. Please fix the errors"
        end

        it 'redirects back' do
          delete_destroy(group.id)
          expect(response).to redirect_to 'back'
        end
      end
    end

    context 'without logged in user' do
      before { delete_destroy(group.id) }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #metrics' do
    context 'with logged user' do
      let!(:updates) { create_list(:group_update, 3, owner: user, group: group) }
      login_user_from_let
      before { get :metrics, id: group.id }

      it 'render metrics template' do
        expect(response).to render_template :metrics
      end

      it 'assigns a valid group object' do
        expect(assigns[:group]).to be_valid
      end

      it 'return 3 updates belonging to group object' do
        expect(assigns[:updates].count).to eq 3
      end
    end

    context 'without logged user' do
      before { get :metrics, id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #import_csv' do
    context 'with logged user' do
      login_user_from_let
      before { get :import_csv, id: group.id }

      it 'render import_csv template' do
        expect(response).to render_template :import_csv
      end

      it 'assigns a valid group object' do
        expect(assigns[:group]).to be_valid
      end
    end

    context 'without logged user' do
      before { get :import_csv, id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #sample_csv' do
    let(:user) { create(:user, enterprise: enterprise) }
    let!(:user_group) { create(:user_group, user: user, group: group) }

    context 'with logged user' do
      login_user_from_let
      before { get :sample_csv, id: group.id }

      it 'returns data in csv format' do
        expect(response.content_type).to eq 'text/csv'
      end

      it "csv filename is 'erg_import_example.csv" do
        expect(response.headers['Content-Disposition']).to include 'erg_import_example.csv'
      end
    end

    context 'without logged user' do
      before { get :sample_csv, id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #parse_csv' do
    let!(:file) { fixture_file_upload('files/members.csv', 'text/csv') }

    context 'with logged user and no file' do
      login_user_from_let

      before {
        request.env['HTTP_REFERER'] = 'back'
        get :parse_csv, id: group.id
      }

      it 'redirects back' do
        expect(response).to redirect_to 'back'
      end

      it 'flashes an alert message' do
        expect(flash[:alert]).to eq 'CSV file is required'
      end
    end

    context 'with logged user' do
      login_user_from_let
      before {
        perform_enqueued_jobs do
          allow(GroupMemberImportCSVJob).to receive(:perform_later)
          get :parse_csv, id: group.id, file: file
        end
      }

      it 'render parse_csv template' do
        expect(response).to render_template :parse_csv
      end

      it 'creates a CsvFile' do
        expect(CsvFile.all.count).to eq(1)
      end

      it 'calls the correct job' do
        expect(GroupMemberImportCSVJob).to have_received(:perform_later)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            allow(GroupMemberImportCSVJob).to receive(:perform_later)
            expect { get :parse_csv, id: group.id, file: file }
            .to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { group }
          let(:owner) { user }
          let(:key) { 'group.import_csv' }

          before {
            perform_enqueued_jobs do
              allow(GroupMemberImportCSVJob).to receive(:perform_later)
              get :parse_csv, id: group.id, file: file
            end
          }

          include_examples 'correct public activity'
        end
      end
    end


    context 'without logged user' do
      before { get :parse_csv, id: group.id, file: file }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #export_csv' do
    context 'with logged user' do
      login_user_from_let
      before {
        allow(GroupMemberDownloadJob).to receive(:perform_later)
        request.env['HTTP_REFERER'] = 'back'
        get :export_csv, id: group.id
      }

      it 'redirects to user' do
        expect(response).to redirect_to 'back'
      end

      it 'flashes' do
        expect(flash[:notice]).to eq 'Please check your Secure Downloads section in a couple of minutes'
      end

      it 'calls job' do
        expect(GroupMemberDownloadJob).to have_received(:perform_later)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { get :export_csv, id: group.id }.to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { group }
          let(:owner) { user }
          let(:key) { 'group.export_members' }

          before {
            perform_enqueued_jobs do
              get :export_csv, id: group.id
            end
          }

          include_examples 'correct public activity'
        end
      end
    end

    context 'without logged user' do
      before { get :export_csv, id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #edit_fields' do
    context 'with logged user' do
      login_user_from_let
      before { get :edit_fields, id: group.id }

      it 'render edit_fields template' do
        expect(response).to render_template :edit_fields
      end

      it 'assigns a valid group object' do
        expect(assigns[:group]).to be_valid
      end
    end

    context 'without logged user' do
      before { get :edit_fields, id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #delete_attachment' do
    def get_delete_attachment
      request.env['HTTP_REFERER'] = 'back'
      get :delete_attachment, id: group.id
    end

    context 'with logged user' do
      login_user_from_let
      before { get_delete_attachment }

      it 'flashes a notice message' do
        expect(flash[:notice]).to eq 'Group attachment was removed'
      end

      it 'redirects to previous page' do
        expect(response).to redirect_to 'back'
      end
    end

    context 'with logged user and non-destroy' do
      login_user_from_let

      before do
        allow_any_instance_of(Group).to receive(:save).and_return(false)
        request.env['HTTP_REFERER'] = 'back'
        get_delete_attachment
      end

      it 'renders back' do
        expect(response).to redirect_to 'back'
      end

      it 'flashes an alert message' do
        expect(flash[:alert]).to eq 'Group attachment was not removed. Please fix the errors'
      end
    end

    context 'without logged user' do
      before { get_delete_attachment }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#sort' do
    context 'with logged in user' do
      let!(:group1) { create(:group, enterprise: enterprise) }
      let!(:group2) { create(:group, enterprise: enterprise) }
      let!(:group3) { create(:group, enterprise: enterprise) }

      login_user_from_let

      before do
        group_ids = enterprise.groups.pluck(:id).map(&:to_s)
        params = { 'group' => group_ids }
        post :sort, params
      end

      it 'render nothing' do
        expect(response).to render_template(nil)
      end

      it 'apply sorting by assigning an integer to position attribute for each group' do
        expect(group1.reload.position).to_not be_nil
        expect(group2.reload.position).to_not be_nil
        expect(group3.reload.position).to_not be_nil
      end
    end
  end

  describe 'PATCH#auto_archive_switch' do
    context 'with logged in user' do
      login_user_from_let

      before { group.update(expiry_age_for_news: 1) }

      it 'turns auto_archive_switch on for group' do
        xhr :patch, :auto_archive_switch, id: group.id, format: :js
        expect(assigns[:group].auto_archive).to eq true
      end

      it 'turns auto_archive off for group' do
        group.update auto_archive: true
        xhr :patch, :auto_archive_switch, id: group.id, format: :js
        expect(assigns[:group].auto_archive).to eq false
      end

      it 'renders nothing' do
        xhr :patch, :auto_archive_switch, id: group.id, format: :js
        expect(response).to render_template(nil)
      end
    end
  end
end
