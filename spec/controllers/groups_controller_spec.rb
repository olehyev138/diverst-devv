require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  
  let(:enterprise){ create(:enterprise, cdo_name: "test") }
  let(:user){ create(:user, enterprise: enterprise, email: "test@gmail.com") }
  let(:group){ create(:group, enterprise: enterprise) }

  describe 'GET #index' do
    def get_index
      get :index
    end

    context 'with logged user' do
      login_user_from_let

      before { get_index }

      it 'render template' do
        expect(response).to render_template :index
      end

      it "return success" do
        expect(response).to have_http_status(:ok)
      end


      it 'correctly sets groups' do
        expect(group.enterprise).to eq enterprise
      end
    end

    context 'without logged user' do
      before { get_index }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'GET #close_budgets' do
    def get_show
      get :close_budgets, :id => group.id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_show }

      it 'return success' do
        expect(response).to be_success
      end
    end
  end

  describe 'GET#plan_overview' do
    def get_plan_overview
      get :plan_overview
    end
    let!(:user) { create :user }
    let!(:group) { create(:group, enterprise: user.enterprise) }

    context 'with logged user' do
      let!(:foreign_group) { FactoryGirl.create :group }

      login_user_from_let

      before { get_plan_overview }

      it 'render plan_overview template' do
        expect(response).to render_template :plan_overview
      end

      it 'shows groups from correct enterprise' do
        groups = assigns(:groups)

        expect(groups).to include group
        expect(groups).to_not include foreign_group
      end
    end

    context 'without logged user' do
      before { get_plan_overview }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'GET #calendar' do
    def get_calendar
      get :calendar
    end

    context 'with logged user' do
      login_user_from_let

      before { get_calendar }

      it "render 'shared/calendar/calendar_view" do
        expect(response).to render_template('shared/calendar/calendar_view')
      end

      it "responds with success" do
        should respond_with :success
      end
    end

    context 'without logged user' do
      before { get_calendar }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  #Derek
  describe 'GET #calendar_data' do
    def get_calendar_data(initiative_participating_groups_id_in, initiative_segments_segement_id_in, params={})
      get :calendar_data, params, q: { initiative_participating_groups_group_id_in: initiative_participating_groups_id_in, initiative_segments_segement_id_in: initiative_segments_segement_id_in }, format: :json
    end

    let(:initiative) { create :initiative }
    let(:group) { create :group, enterprise_id: enterprise.id }
    let(:event) { create :event, group_id: group.id }
    let(:initiative_group) { create :initiative_group, group_id: group.id, initiative_id: initiative.id }
    let(:initiative_segment) { create :initiative_segment, initiative_id: initiative.id }

    context 'with logged in user' do
      let!(:enterprise) { create :enterprise }
      login_user_from_let

      before { get_calendar_data(initiative_group.id, initiative_segment.id, params={token: 'uniquetoken1234'}) }

      it 'fetches correct events' do
        expect(event.group_id).to eq group.id
      end
    end

    context 'without logged in user' do

      context 'with incorrect token code' do
        let!(:enterprise) { create :enterprise, iframe_calendar_token: 'uniquetoken1234' }

        it 'returns error' do
          expect{ get_calendar_data(initiative_group.id, initiative_segment.id, params={ token: 'incorrect token' }) }.to raise_error(Pundit::NotAuthorizedError)
        end
      end

      context 'without token code' do
        it 'should raise Pundit::NotAuthorizedError' do
        expect{ get_calendar_data(initiative_group.id, initiative_segment.id) }.to raise_error(Pundit::NotAuthorizedError)
         end
      end
    end
  end

  describe 'GET #new' do
    def get_new
      get :new
    end

    context 'with logged user' do
      login_user

      before { get_new }

      it 'return success' do
        expect(response).to be_success
      end
    end

    context 'without logged user' do
      before { get_new }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'GET #show' do
    def get_show
      get :show, :id => group.id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_show }

      it 'return success' do
        expect(response).to be_success
      end

      describe 'members list' do
        let(:group){ create(:group, enterprise: enterprise, pending_users: 'enabled') }

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

        def members
          assigns[:members]
        end

        before { get_show }

        it 'shows active users' do
          expect(members).to include active_user
        end

        it 'does not show pending users' do
          expect(members).to_not include pending_user
        end

        it 'does not show inactive users' do
          expect(members).to_not include inactive_user
        end
      end
    end
    
    context 'with logged regular user group member' do
      
      let(:policy_group){ create(:policy_group, :global_settings_manage => true, :groups_manage => false)}
      let(:user){ create(:user, :enterprise => enterprise, :policy_group => policy_group) }
      let!(:user_group){ create(:user_group, :group => group, :user => user, :accepted_member => true)}
      
      login_user_from_let

      before { get_show }

      it 'return success' do
        expect(response).to be_success
      end
    end
    
    context 'with logged regular user non-group member' do
      
      let(:policy_group){ create(:policy_group, :global_settings_manage => true, :groups_manage => false)}
      let(:user){ create(:user, :enterprise => enterprise, :policy_group => policy_group) }
      
      login_user_from_let

      before { get_show }

      it 'return success' do
        expect(response).to be_success
      end
    end

    context 'without logged user' do
      before { get_show }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'POST #create' do
    def post_create(params={a: 1})
      post :create, group: params
    end

    context 'with logged in user' do
      let(:user) { create :user }
      let(:group_attrs) { attributes_for :group }

      login_user_from_let

      context 'with correct params' do
        it 'creates group' do
          expect{
            post_create(group_attrs)
          }.to change(Group, :count).by(1)
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
            expect{
              post_create(group_attrs)
            }.to change(PublicActivity::Activity, :count).by(1)
          end

          describe 'activity record' do
            let(:model) { Group.last }
            let(:owner) { user }
            let(:key) { 'group.create' }

            before {
              post_create(group_attrs)
            }

            include_examples'correct public activity'
          end
        end
      end

      context 'with incorrect params' do
        it 'does not save the new group' do
          expect{ post_create() }
            .to_not change(Group, :count)
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

    context 'without logged in user' do
      before { post_create }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'GET #edit' do
    def get_edit
      get :edit, :id => group.id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_edit }

      it 'return success' do
        expect(response).to be_success
      end
    end

    context 'without logged user' do
      before { get_edit }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'PATCH #update' do
    def patch_update( group_id = -1, params = {})
      patch :update, id: group_id, group: params
    end

    let(:user) { create :user }
    let!(:group) { create :group, enterprise: user.enterprise }

    before { set_referrer }

    context 'with logged in user' do
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
            expect{
              patch_update(group.id, group_attrs)
            }.to change(PublicActivity::Activity, :count).by(1)
          end

          describe 'activity record' do
            let(:model) { Group.last }
            let(:owner) { user }
            let(:key) { 'group.update' }

            before {
              patch_update(group.id, group_attrs)
            }

            include_examples'correct public activity'
          end
        end

        it 'redirects to correct page' do
          patch_update(group.id, group_attrs)

          expect(response).to redirect_to default_referrer
        end
      end

      context 'with incorrect params' do
        before { patch_update(group.id, { name: '' }) }

        it 'does not update indsitiative' do
          updated_group = Group.find(group.id)

          expect(updated_group.name).to eq group.name
          expect(updated_group.description).to eq group.description
        end

        it 'renders edit view' do
          expect(response).to render_template :settings
        end
      end
    end

    context 'without logged in user' do
      before { patch_update(group.id) }

      it 'return error' do
        expect(response).to_not be_success
      end
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

      context 'with incorrect group' do
      end

      context 'with group user can\'t manage' do
      end

      context 'with group user can manage' do
        let(:group) { create :group, enterprise: user.enterprise, owner: user }

        it 'return success' do
          expect(response).to be_success
        end
      end
    end

    context 'without logged user' do
      before { get_settings }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    def delete_destroy(group_id = -1)
      request.env["HTTP_REFERER"] = "back"
      delete :destroy, id: group_id
    end

    let(:user) { create :user }
    let!(:group) { create :group, enterprise: user.enterprise }

    context 'with logged in user' do
      login_user_from_let

      context 'with correct params' do
        it 'deletes initiative' do
          expect{
            delete_destroy(group.id)
          }.to change(Group, :count).by(-1)
        end

        it 'redirects to correct action' do
          delete_destroy(group.id)

          expect(response).to redirect_to  action: :index
        end

          describe 'public activity' do
            enable_public_activity

            it 'creates public activity record' do
              expect{
                delete_destroy(group.id)
              }.to change(PublicActivity::Activity, :count).by(1)
            end

            describe 'activity record' do
              let(:model) { Group.last }
              let(:owner) { user }
              let(:key) { 'group.destroy' }

              before {
                delete_destroy(group.id)
              }

              include_examples'correct public activity'
            end
          end
      end
      
      context 'when not saving' do
        before {allow_any_instance_of(Group).to receive(:destroy).and_return(false)}
        it 'redirects back' do
          delete_destroy(group.id)
          expect(response).to redirect_to  "back"
        end
      end
    end

    context 'without logged in user' do
      it 'return error' do
        delete_destroy(group.id)
        expect(response).to_not be_success
      end

      it 'do not change Group count' do
        expect {
          delete_destroy(group.id)
        }.to_not change(Group, :count)
      end
    end
  end

  describe 'GET #metrics' do
    def get_metrics
      get :metrics, :id => group.id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_metrics }

      it 'return success' do
        expect(response).to be_success
      end
    end

    context 'without logged user' do
      before { get_metrics }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'GET #import_csv' do
    def get_import_csv
      get :import_csv, :id => group.id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_import_csv }

      it 'return success' do
        expect(response).to be_success
      end
    end

    context 'without logged user' do
      before { get_import_csv }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'GET #sample_csv' do
    let(:user){ create(:user, enterprise: enterprise) }
    let!(:user_group){ create(:user_group, user: user, group: group) }
  
    def get_sample_csv
      get :sample_csv, :id => group.id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_sample_csv }

      it 'return success' do
        expect(response).to be_success
      end
    end

    context 'without logged user' do
      before { get_sample_csv }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'GET #parse_csv' do

    def get_parse_csv
      file = fixture_file_upload('files/test.csv', 'text/csv')
      get :parse_csv, :id => group.id, :file => file
    end

    context 'with logged user' do
      login_user_from_let

      before { get_parse_csv }

      it 'return success' do
        expect(response).to be_success
      end
    end
    
    context 'with logged user and users in file' do
      login_user_from_let

      before do
        file = fixture_file_upload('files/test_2.csv', 'text/csv')
        get :parse_csv, :id => group.id, :file => file
      end

      it 'return success' do
        expect(response).to be_success
      end
    end

    context 'without logged user' do
      before { get_parse_csv }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'GET #export_csv' do

    def get_export_csv
      get :export_csv, :id => group.id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_export_csv }

      it 'return success' do
        expect(response).to be_success
      end
    end

    context 'without logged user' do
      before { get_export_csv }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'GET #edit_fields' do

    def get_edit_fields
      get :edit_fields, :id => group.id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_edit_fields }

      it 'return success' do
        expect(response).to be_success
      end
    end

    context 'without logged user' do
      before { get_edit_fields }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'GET #delete_attachment' do

    def get_delete_attachment
      request.env["HTTP_REFERER"] = "back"
      get :delete_attachment, :id => group.id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_delete_attachment }

      it 'return success' do
        expect(response).to redirect_to "back"
      end
    end
    
    context 'with logged user and non-destroy' do
      login_user_from_let

      before do
        allow_any_instance_of(Group).to receive(:save).and_return(false)
        request.env["HTTP_REFERER"] = "back"
        get_delete_attachment
      end

      it 'renders back' do
        expect(response).to redirect_to "back"
      end
      
      it 'flashes' do
        expect(flash[:alert]).to eq "Group attachment was not removed. Please fix the errors"
      end
    end

    context 'without logged user' do
      before { get_delete_attachment }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end
end
