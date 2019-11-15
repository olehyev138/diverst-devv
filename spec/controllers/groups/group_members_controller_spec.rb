require 'rails_helper'

RSpec.describe Groups::GroupMembersController, type: :controller do
  include ActiveJob::TestHelper

  let(:user) { create :user }
  let(:add) { create :user, enterprise: user.enterprise }
  let(:group) { create(:group, enterprise: user.enterprise) }
  let!(:user_group) { create(:user_group, group_id: group.id, user_id: user.id) }
  let!(:group_role) { user.enterprise.user_roles.group_type.first }

  describe 'GET#index' do
    context 'with user logged in' do
      let!(:user_group1) { create(:user_group, group_id: group.id, user_id: add.id) }
      let!(:segments) { create_list(:segment, 2, owner: user, enterprise: user.enterprise) }
      login_user_from_let
      before { get :index, group_id: group.id }

      it 'renders index template' do
        expect(response).to render_template :index
      end

      it 'get valid group object' do
        expect(assigns[:group]).to be_valid
      end

      it 'returns members' do
        expect(assigns[:members]).to eq [user, add]
      end

      it 'returns total_members equals 2' do
        expect(assigns[:total_members]).to eq 2
      end

      it 'returns 2 segments belonging to group object' do
        expect(assigns[:segments]).to eq segments
      end
    end

    context 'returns format in json' do
      login_user_from_let
      before { get :index, group_id: group.id, format: :json }

      it 'returns format in json' do
        expect(response.content_type).to eq 'application/json'
      end
    end

    context 'with user not logged in' do
      before { get :index, group_id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#pending' do
    context 'when user is logged in' do
      let!(:user1) { create(:user) }
      let!(:user_group1) { create(:user_group, group_id: group.id, user_id: user1.id, accepted_member: false) }
      login_user_from_let
      before do
        get :pending, group_id: group.id
      end

      it 'render pending template' do
        expect(response).to render_template :pending
      end

      it 'set valid group object' do
        expect(assigns[:group]).to be_valid
      end

      it 'return 1 pending member' do
        assigns[:group].pending_users = 'enabled'
        expect(assigns[:group].pending_members).to eq [user1]
      end
    end

    context 'with user not logged in' do
      before { get :pending, group_id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#accept_pending' do
    describe 'with logged in user' do
      login_user_from_let
      before { user_group.save }

      it 'accepts pending member' do
        post :accept_pending, group_id: group.id, id: user.id
        expect(assigns[:group].members).to include user
      end

      it 'redirects to pending action after it accepts the pending member' do
        post :accept_pending, group_id: group.id, id: user.id
        expect(response).to redirect_to action: :pending
      end

      context 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { post :accept_pending, group_id: group.id, id: user.id
            }.to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { User.last }
          let(:owner) { user }
          let(:key) { 'user.accept_pending' }

          before {
            perform_enqueued_jobs do
              post :accept_pending, group_id: group.id, id: user.id
            end
          }
          include_examples 'correct public activity'
        end
      end
    end

    describe 'without logged in user' do
      before { post :accept_pending, group_id: group.id, id: user.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#new' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :new, group_id: group.id }

      it 'renders new template' do
        expect(response).to render_template :new
      end

      it 'gets a valid group object' do
        expect(assigns[:group]).to be_valid
      end
    end

    context 'when user is not logged in' do
      before { get :new, group_id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'DELETE#destroy' do
    describe 'when user is logged in' do
      login_user_from_let

      context 'before removing' do
        it 'makes sure group count is 1' do
          user_group.save
          expect(group.members.count).to eq(1)
        end
      end

      context 'when leaving parent group' do
        let!(:sub_group) { create(:group, enterprise: user.enterprise, parent_id: group.id) }
        let!(:group_leader) { create(:group_leader, user_id: user.id, group_id: group.id, user_role_id: group_role.id) }
        before do
          UserGroup.create(user_id: user.id, group_id: sub_group.id, accepted_member: true)
          delete :destroy, group_id: group.id, id: user.id
        end

        it 'leave all sub groups' do
          expect(group.members).not_to include assigns[:current_user]
          expect(sub_group.members).to include assigns[:current_user]
        end

        it 'delete all membership to sub groups joined previously' do
          expect(assigns[:group].user_groups.count).to eq 0
        end

        it 'delete all group leadership details if group leader' do
          expect(user.is_group_leader_of? group).to eq false
        end
      end
    end

    describe 'when user is not logged in' do
      before { delete :destroy, group_id: group.id, id: user.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#create' do
    context 'when unsuccessful' do
      login_user_from_let

      before do
        allow_any_instance_of(UserGroup).to receive(:save).and_return(false)
      end

      it 'renders new template' do
        post :create, group_id: group.id, user: { user_id: add.id }
        expect(response).to render_template :new
      end

      it 'flashes an alert message' do
        post :create, group_id: group.id, user: { user_id: add.id }
        expect(flash[:alert])
      end

      it "doesn't create the user" do
        group.reload
        expect { post :create, group_id: group.id, user: { user_id: add.id } }
        .to change(group.members, :count).by(0)
      end
    end

    context 'before creating' do
      login_user_from_let

      it 'makes sure group count is 1' do
        user_group.save
        expect(group.members.count).to eq(1)
      end

      context 'when creating with survey fields' do
        let(:field) { create(:field, field_type: 'group_survey', type: 'NumericField', group: group, elasticsearch_only: false) }

        before do
          user_group.save
          field.save
        end

        it 'redirects to survey group questions path' do
          post :create, group_id: group.id, user: { user_id: add.id }
          expect(response).to redirect_to survey_group_questions_path(group)
        end

        it 'flashes a notice message' do
          post :create, group_id: group.id, user: { user_id: add.id }
          expect(flash[:notice]).to eq 'You are now a member'
        end

        it 'group membership increases by one' do
          group.reload
          expect { post :create, group_id: group.id, user: { user_id: add.id } }
          .to change(group.members, :count).by(1)
        end
      end

      context 'when creating without survey fields' do
        before do
          user_group.save
          request.env['HTTP_REFERER'] = 'back'
        end

        it 'redirects to previous page' do
          post :create, group_id: group.id, user: { user_id: add.id }
          expect(response).to redirect_to group_path(group)
        end

        it 'flashes a notice message' do
          post :create, group_id: group.id, user: { user_id: add.id }
          expect(flash[:notice]).to eq 'You are now a member'
        end

        it 'creates the user' do
          group.reload
          expect { post :create, group_id: group.id, user: { user_id: add.id } }
          .to change(group.members, :count).by(1)
        end
      end

      context 'when group is default mentor group' do
        it 'redirects to mentor profile' do
          # set group as default mentor group
          group.default_mentor_group = true
          group.save!

          post :create, group_id: group.id, user: { user_id: add.id }
          expect(response).to redirect_to edit_user_mentorship_path(id: user.id)
        end
      end
    end

    context 'when user is not logged in' do
      before { post :create, group_id: group.id, user: { user_id: add.id } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#show' do
    context 'when users is logged in' do
      login_user_from_let
      before { get :show, group_id: group.id, id: user.id }

      it 'renders show template' do
        expect(response).to render_template :show
      end

      it 'displays a user which is a group member' do
        expect(assigns[:user]).to eq user_group.user
      end

      it 'displays a valid group_member' do
        expect(assigns[:user]).to be_valid
      end
    end
  end

  describe 'GET#edit' do
    context 'when user is logged in' do
      login_user_from_let

      it 'render template' do
        get :edit, group_id: group.id, id: user.id
        expect(response).to render_template :edit
      end

      it 'returns a valid user object' do
        get :edit, group_id: group.id, id: user.id
        expect(assigns[:user]).to be_valid
      end
    end

    context 'when user is not logged in' do
      before { get :edit, group_id: group.id, id: user.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#update' do
    describe 'when user is logged in' do
      login_user_from_let

      context 'for a successful update' do
        let(:new_user_role) { create(:user_role, enterprise: user.enterprise, role_name: 'Test', priority: 10, role_type: 'user') }

        before do
          request.env['HTTP_REFERER'] = 'back'
          patch :update, group_id: group.id, id: user.id, user: { first_name: 'updated', user_role_id: new_user_role.id }
        end

        it 'redirects to user' do
          expect(response).to redirect_to 'back'
        end

        it 'updates the user' do
          user.reload
          expect(user.first_name).to eq('updated')
          expect(user.user_role_id).to eq(new_user_role.id)
        end

        it 'flashes a notice message' do
          expect(flash[:notice]).to eq 'Your user was updated'
        end
      end

      context 'for an unsuccessful update' do
        before { patch :update, group_id: group.id, id: user.id, user: { email: 'bademail' } }

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your user was not updated. Please fix the errors'
        end

        it 'render edit template' do
          expect(response).to render_template :edit
        end
      end
    end

    describe 'when user is not logged in' do
      before do
        request.env['HTTP_REFERER'] = 'back'
        patch :update, group_id: group.id, id: user.id, user: { first_name: 'updated' }
      end
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#add_members' do
    context 'when user is logged in' do
      login_user_from_let
      let(:user_group2) { create(:user_group, group_id: group.id, user_id: add.id) }

      it 'redirects to index action' do
        post :add_members, group_id: group.id, group: { member_ids: [add.id] }
        expect(response).to redirect_to action: 'index'
      end

      it 'adds the users' do
        expect { post :add_members, group_id: group.id, group: { member_ids: [add.id] } }
        .to change(group.members, :count).by(1)
      end

      it 'sets accepted_member attribute to true when user is added to a group with pending_users disabled' do
        post :add_members, group_id: group.id, group: { member_ids: [add.id] }
        expect(add.user_groups.last.accepted_member).to eq true
      end

      context 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { post :add_members, group_id: group.id, group: { member_ids: [add.id] }
            }.to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { group }
          let(:owner) { user }
          let(:key) { 'group.add_members_to_group' }

          before {
            perform_enqueued_jobs do
              post :add_members, group_id: group.id, group: { member_ids: [add.id] }
            end
          }
          include_examples 'correct public activity'
        end
      end
    end

    context 'when user is not logged in' do
      before { post :add_members, group_id: group.id, user_id: add.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'DELETE#remove_member' do
    context 'when user is logged in' do
      let!(:group_leader) { create(:group_leader, user_id: user.id, group_id: group.id, user_role_id: group_role.id) }
      login_user_from_let
      before { user_group.save }

      it 'redirects to index action' do
        delete :remove_member, group_id: group.id, id: user.id
        expect(response).to redirect_to action: 'index'
      end

      it 'removes the user' do
        delete :remove_member, group_id: group.id, id: user.id
        expect(UserGroup.where(user_id: user.id, group_id: group.id).count).to eq(0)
      end

      it 'deletes the leader' do
        delete :remove_member, group_id: group.id, id: user.id
        expect { GroupLeader.find(group_leader.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      context 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { delete :remove_member, group_id: group.id, id: user.id
            }.to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { group }
          let(:owner) { user }
          let(:key) { 'group.remove_member_from_group' }

          before {
            perform_enqueued_jobs do
              delete :remove_member, group_id: group.id, id: user.id
            end
          }
          include_examples 'correct public activity'
        end
      end
    end

    context 'when user is not logged in' do
      before { delete :remove_member, group_id: group.id, id: user.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#join_all_sub_groups' do
    context 'when user is logged in' do
      login_user_from_let
      let!(:sub_group1) { create(:group, enterprise: user.enterprise, parent_id: group.id) }
      let!(:sub_group2) { create(:group, enterprise: user.enterprise, parent_id: group.id) }

      context 'and group has pending users disabled' do
        before { group.update(pending_users: 'disabled') }

        it 'automatically join sub groups and becomes a member of each' do
          post :join_all_sub_groups, group_id: group.id

          sub_group1_member = UserGroup.find_by(group_id: sub_group1.id, user_id: assigns[:current_user].id)
          sub_group2_member = UserGroup.find_by(group_id: sub_group2.id, user_id: assigns[:current_user].id)

          expect(sub_group1_member.accepted_member).to eq true
          expect(sub_group2_member.accepted_member).to eq true
        end

        it 'display a notice message' do
          post :join_all_sub_groups, group_id: group.id
          expect(flash[:notice]).to eq "You've joined all #{c_t(:sub_erg).pluralize} of #{assigns[:group].name}"
        end

        context 'when survey fields for group is present' do
          before { create(:field, field_type: 'group_survey', group_id: group.id) }
          it 'redirect to survey_group_questions_path' do
            post :join_all_sub_groups, group_id: group.id
            expect(response).to redirect_to survey_group_questions_path(group)
          end
        end

        context 'when survey fields for group is absent' do
          it 'redirect to survey_group_questions_path' do
            post :join_all_sub_groups, group_id: group.id
            expect(response).to redirect_to group_path(group)
          end
        end
      end

      context 'and group has pending users enabled' do
        before { group.update(pending_users: 'enabled') }

        it 'automatically join sub groups and is a pending member of each' do
          post :join_all_sub_groups, group_id: group.id

          sub_group1_member = UserGroup.find_by(group_id: sub_group1.id, user_id: assigns[:current_user].id)
          sub_group2_member = UserGroup.find_by(group_id: sub_group2.id, user_id: assigns[:current_user].id)

          expect(sub_group1_member.accepted_member).to eq false
          expect(sub_group2_member.accepted_member).to eq false
        end

        it 'display a notice message' do
          post :join_all_sub_groups, group_id: group.id
          expect(flash[:notice]).to eq "You've joined all #{c_t(:sub_erg).pluralize} of #{assigns[:group].name}"
        end

        context 'when survey fields for group is present' do
          before { create(:field, type: 'TextField', field_type: 'group_survey', group_id: group.id) }

          it 'redirect to survey_group_questions_path' do
            post :join_all_sub_groups, group_id: group.id
            expect(response).to redirect_to survey_group_questions_path(group)
          end
        end
      end

      context 'when survey fields for group is absent' do
        before do
          group.update(pending_users: 'enabled')
          post :join_all_sub_groups, group_id: group.id
        end

        it 'redirect to survey_group_questions_path' do
          expect(response).to redirect_to group_path(group)
        end
      end
    end
  end

  describe 'POST#export_sub_groups_members_list_csv' do
    context 'when user is logged in' do
      let!(:sub_group) { create(:group, parent: group, enterprise: user.enterprise) }
      let!(:member) { create(:user_group, user_id: create(:user).id, group_id: sub_group.id) }
      login_user_from_let

      before do
        allow(GroupMemberListDownloadJob).to receive(:perform_later)
        request.env['HTTP_REFERER'] = 'back'
        post :export_sub_groups_members_list_csv, group_id: group.id, groups: { sub_group.name => sub_group.id }
      end

      it 'redirects to user' do
        expect(response).to redirect_to 'back'
      end

      it 'flashes' do
        expect(flash[:notice]).to eq 'Please check your Secure Downloads section in a couple of minutes'
      end

      it 'calls job' do
        expect(GroupMemberListDownloadJob).to have_received(:perform_later)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { post :export_sub_groups_members_list_csv, group_id: group.id, groups: { sub_group.name => sub_group.id } }.to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { group }
          let(:owner) { user }
          let(:key) { 'group.export_sub_groups_members_list' }

          before {
            perform_enqueued_jobs do
              post :export_sub_groups_members_list_csv, group_id: group.id, groups: { sub_group.name => sub_group.id }
            end
          }

          include_examples 'correct public activity'
        end
      end
    end
  end

  describe 'GET#export_group_members_list_csv' do
    context 'when user is logged in' do
      let!(:active_members) { create_list(:user, 5, enterprise_id: user.enterprise.id, user_role_id: user.user_role_id, active: true) }
      let!(:inactive_members) { create_list(:user, 5, enterprise_id: user.enterprise.id, user_role_id: user.user_role_id, active: false) }
      login_user_from_let

      before do
        allow(GroupMemberListDownloadJob).to receive(:perform_later)
        request.env['HTTP_REFERER'] = 'back'
        group.members << active_members
        create(:group_leader, user: user, group: group)
        get :export_group_members_list_csv, group_id: group.id
      end

      it 'redirects to user' do
        expect(response).to redirect_to 'back'
      end

      it 'flashes' do
        expect(flash[:notice]).to eq 'Please check your Secure Downloads section in a couple of minutes'
      end

      it 'calls job' do
        expect(GroupMemberListDownloadJob).to have_received(:perform_later)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { get :export_group_members_list_csv, group_id: group.id }.to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { group }
          let(:owner) { user }
          let(:key) { 'group.export_member_list' }

          before {
            perform_enqueued_jobs do
              get :export_group_members_list_csv, group_id: group.id
            end
          }

          include_examples 'correct public activity'
        end
      end
    end
  end
end
