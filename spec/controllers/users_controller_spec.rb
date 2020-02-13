require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }

  describe 'GET#index' do
    context 'when user is logged in' do
      login_user_from_let

      it 'returns an html response' do
        get :index
        expect(response.content_type).to eq 'text/html'
      end

      it 'renders index template' do
        get :index
        expect(response).to render_template :index
      end

      it 'returns a json response' do
        get :index, format: :json
        expect(response.content_type).to eq 'application/json'
      end

      it 'returns 2 UserDatatable objects in json' do
        create(:user, enterprise: enterprise)
        get :index, format: :json
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:recordsTotal]).to eq 2
      end

      it 'returns users' do
        get :index
        expect(assigns[:users]).to eq [user]
      end

      describe 'return correct users based on group membership params; :accepted_member and :group_id' do
        let!(:group) { create(:group, enterprise: enterprise) }
        let!(:other_group) { create(:group, enterprise: enterprise) }
        let!(:group_membership) { create(:user_group, user_id: user.id, group_id: group.id, accepted_member: true) }
        let!(:other_user) { create(:user, enterprise: enterprise) }
        let!(:other_group_membership) { create(:user_group, user_id: other_user.id, group_id: other_group.id, accepted_member: true) }
        let!(:search_params) { { accepted_member: true, group_id: group.id } }


        it 'returns 1 UserDatatable object in json' do
          get :index, user_groups: search_params, format: :json

          json_response = JSON.parse(response.body, symbolize_names: true)
          expect(json_response[:recordsTotal]).to eq 1
        end

        it 'returns only users that are members of group' do
          get :index, user_groups: search_params
          expect(assigns[:users]).to eq [user]
        end
      end

      context 'with extra params' do
        let!(:user2) { create(:user, enterprise: user.enterprise) }
        let(:policy_group) { create(:policy_group, :no_permissions) }
        let!(:user_without_perms) { create(:user, enterprise: user.enterprise) }

        it 'not_current_user' do
          get :index, not_current_user: true, format: :json

          json_response = response.body
          expect(json_response).not_to include(user.email)
          expect(json_response).to include(user2.email)
          expect(json_response).to include(user_without_perms.email)
        end

        it 'can_metrics_dashboard_create' do
          user_without_perms.policy_group = policy_group
          get :index, can_metrics_dashboard_create: true, format: :json

          json_response = response.body
          expect(json_response).to include(user.email)
          expect(json_response).to include(user2.email)
          expect(json_response).not_to include(user_without_perms.email)
        end
      end
    end

    context 'when user is not logged in' do
      before { get :index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#sent_invitations' do
    context 'when user is logged in' do
      login_user_from_let

      it 'returns a json response' do
        get :sent_invitations, format: :json
        expect(response.content_type).to eq 'application/json'
      end
    end

    context 'when user is not logged in' do
      before { get :sent_invitations, format: :json }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#saml_logins' do
    context 'when user is logged in' do
      login_user_from_let

      it 'returns data in json' do
        get :saml_logins, format: :json
        expect(response.content_type).to eq 'application/json'
      end

      it 'returns users' do
        create(:user, enterprise: enterprise, auth_source: 'saml')
        get :saml_logins
        expect(assigns[:users].count).to eq 1
      end

      it 'returns a new UserDatatable object in json' do
        create(:user, enterprise: enterprise, auth_source: 'saml')
        get :saml_logins, format: :json
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:recordsTotal]).to eq 1
      end
    end

    context 'when user is not logged in' do
      before { get :saml_logins, format: :json }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  # NOTE: Missing Template for new method

  describe 'GET#show' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :show, id: user.id }


      it 'render show template' do
        expect(response).to render_template :show
      end

      it 'returns a valid user' do
        expect(assigns[:user]).to be_valid
      end
    end

    context 'when user is not logged in' do
      before { get :show, id: user.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#group_surveys' do
    context 'when user is logged in' do
      let!(:groups) { create_list(:group, 2, enterprise: enterprise) }
      let!(:user_group1) { create(:user_group, user: user, group_id: groups.first.id, data: 'some text') }
      let!(:user_group2) { create(:user_group, user: user, group_id: groups.last.id, data: 'some text') }
      let!(:user2) { create(:user, enterprise: enterprise) }

      login_user_from_let

      it 'returns success' do
        get :group_surveys, id: user.id, group_id: groups.first.id
        expect(response).to be_success
      end

      it 'returns user groups with data attribute not set to nil' do
        get :group_surveys, id: user.id, group_id: user_group2.group.id
        expect(assigns[:user_groups].count).to eq 1
      end

      context 'with incorrect group' do
        it 'returns an empty user groups' do
          get :group_surveys, id: user.id, group_id: create(:group).id
          expect(assigns[:user_groups]).to be_empty
        end
      end

      context 'with no group specified' do
        context 'user belongs to group with survey' do
          it 'returns groups with surveys for users groups' do
            get :group_surveys, id: user.id, group_id: nil
            expect(assigns[:user_groups]).to eq user.user_groups
          end
        end
      end
    end

    context 'when user is not logged in' do
      before { get :group_surveys, id: user.id, group_id: groups.first.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#edit' do
    context 'when user is logged in' do
      login_user_from_let

      it 'render template' do
        get :edit, id: user.id
        expect(response).to render_template :edit
      end

      it 'returns a valid user object' do
        get :edit, id: user.id
        expect(assigns[:user]).to be_valid
      end
    end

    context 'when user is not logged in' do
      before { get :edit, id: user.id }
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
          patch :update, id: user.id, user: { first_name: 'updated', user_role_id: new_user_role.id }
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
        before { patch :update, id: user.id, user: { email: 'bademail' } }

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
        patch :update, id: user.id, user: { first_name: 'updated' }
      end
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'delete#destroy' do
    let!(:new_user) { create(:user, enterprise: enterprise) }
    context 'when user is logged in' do
      login_user_from_let
      before do
        request.env['HTTP_REFERER'] = 'back'
      end

      it 'redirects to previous url' do
        delete :destroy, id: user.id
        expect(response).to redirect_to 'back'
      end

      it 'does not delete the user when user and current user are the same' do
        expect { delete :destroy, id: user.id }
        .to change(User, :count).by(0)
      end

      it 'deletes user' do
        expect { delete :destroy, id: new_user.id }
        .to change(User, :count).by(-1)
      end
    end

    context 'when user is not logged in' do
      before do
        request.env['HTTP_REFERER'] = 'back'
        delete :destroy, id: user.id
      end
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#resend_invitation' do
    context 'when user is logged in' do
      login_user_from_let
      before do
        request.env['HTTP_REFERER'] = 'back'
        patch :resend_invitation, id: user.id
      end


      it 'updates the user invitation_sent_at' do
        user.reload
        expect(user.invitation_sent_at.in_time_zone('UTC').wday).to eq(Time.now.in_time_zone('UTC').wday)
      end

      it 'flashes a notice message' do
        expect(flash[:notice]).to eq 'Invitation Re-Sent!'
      end

      it 'redirects to back' do
        expect(response).to redirect_to 'back'
      end
    end

    context 'when user is not logged in' do
      before do
        request.env['HTTP_REFERER'] = 'back'
        patch :resend_invitation, id: user.id
      end
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#sample_csv' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :sample_csv }

      it 'returns response in csv format' do
        expect(response.content_type).to eq 'text/csv'
      end

      it 'download sample csv with the following headers: first name, last name, email, biography, active' do
        expect(response.body).to include 'First name,Last name,Email,Biography,Active'
      end
    end

    context 'when user is not logged in' do
      before { get :sample_csv }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#import_csv' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :import_csv }

      it 'renders import_csv template' do
        expect(response).to render_template :import_csv
      end
    end

    context 'when user is not logged in' do
      before { get :import_csv }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#parse_csv' do
    let!(:file) { fixture_file_upload('files/diverst_csv_import.csv', 'text/csv') }

    context 'when user is logged in' do
      login_user_from_let

      describe 'response' do
        before {
          perform_enqueued_jobs do
            allow(ImportCSVJob).to receive(:perform_later)
            get :parse_csv, file: file
          end
        }

        it 'renders parse_csv template' do
          expect(response).to render_template :parse_csv
        end

        it 'creates new CsvFile' do
          expect(CsvFile.all.count).to eq(1)
        end

        it 'calls the correct job' do
          expect(ImportCSVJob).to have_received(:perform_later)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              allow(ImportCSVJob).to receive(:perform_later)
              expect { get :parse_csv, file: file }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { User.last }
            let(:owner) { user }
            let(:key) { 'user.import_csv' }

            before {
              perform_enqueued_jobs do
                allow(ImportCSVJob).to receive(:perform_later)
                get :parse_csv, file: file
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'with incorrect file' do
        before {
          request.env['HTTP_REFERER'] = 'back'
          get :parse_csv
        }

        it 'redirects back' do
          expect(response).to redirect_to 'back'
        end

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'CSV file is required'
        end
      end
    end

    context 'when user is not logged in' do
      before { get :parse_csv, file: file }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#export_csv' do
    context 'when user is logged in' do
      login_user_from_let
      before {
        allow(UsersDownloadJob).to receive(:perform_later)
        request.env['HTTP_REFERER'] = 'back'
        get :export_csv
      }

      it 'redirects to user' do
        expect(response).to redirect_to 'back'
      end

      it 'flashes' do
        expect(flash[:notice]).to eq 'Please check your Secure Downloads section in a couple of minutes'
      end

      it 'calls job' do
        expect(UsersDownloadJob).to have_received(:perform_later)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            allow(UsersDownloadJob).to receive(:perform_later)
            expect { get :export_csv }
            .to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { User.last }
          let(:owner) { user }
          let(:key) { 'user.export_csv' }

          before {
            perform_enqueued_jobs do
              allow(UsersDownloadJob).to receive(:perform_later)
              get :export_csv
            end
          }

          include_examples 'correct public activity'
        end
      end
    end

    context 'when user is not logged in' do
      before { get :export_csv }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#date_histogram', skip: 'inconsistent test results' do
    context 'user is logged in' do
      context 'csv' do
        before {
          allow(UsersDateHistogramDownloadJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = 'back'
          get :date_histogram, format: :csv
        }

        it 'redirects to user' do
          expect(response).to redirect_to 'back'
        end

        it 'flashes' do
          expect(flash[:notice]).to eq 'Please check your Secure Downloads section in a couple of minutes'
        end

        it 'calls job' do
          expect(UsersDateHistogramDownloadJob).to have_received(:perform_later)
        end
      end

      context 'json' do
        it 'returns response in json format' do
          get :date_histogram, format: :json
          expect(response.content_type).to eq 'application/json'
        end
      end
    end
  end

  describe 'GET#users_points_ranking' do
    context 'when user is logged in' do
      let!(:inactive_user) { create(:user, enterprise: enterprise, active: false) }
      login_user_from_let
      before { get :users_points_ranking }

      it 'renders users_points_ranking template' do
        expect(response).to render_template :users_points_ranking
      end

      it 'returns active users' do
        expect(assigns[:users]).to eq([user])
      end
    end
  end

  describe 'GET#users_points_csv' do
    context 'when user is logged in' do
      login_user_from_let
      before {
        allow(UsersPointsDownloadJob).to receive(:perform_later)
        request.env['HTTP_REFERER'] = 'back'
        get :users_points_csv
      }

      it 'redirects to user' do
        expect(response).to redirect_to 'back'
      end

      it 'flashes' do
        expect(flash[:notice]).to eq 'Please check your Secure Downloads section in a couple of minutes'
      end

      it 'calls job' do
        expect(UsersPointsDownloadJob).to have_received(:perform_later)
      end
    end

    context 'when user is not logged in' do
      before { get :users_points_csv }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#users_pending_rewards' do
    context 'when user is logged in' do
      let!(:reward) { create(:reward, enterprise: user.enterprise, points: 10) }
      let!(:pending_rewards) { create_list(:user_reward, 2, reward_id: reward.id, points: 10, user_id: user.id, status: 0) }
      login_user_from_let

      before { get :users_pending_rewards }

      it 'renders users_pending_rewards template' do
        expect(response).to render_template :users_pending_rewards
      end

      it 'returns pending_rewards' do
        expect(assigns[:pending_rewards]).to eq(pending_rewards)
      end
    end

    context 'when user is not logged in' do
      before { get :users_pending_rewards }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
