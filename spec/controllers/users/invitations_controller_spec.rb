require 'rails_helper'

RSpec.describe Users::InvitationsController, type: :controller do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }
  let(:custom_text) { create(:custom_text, enterprise: enterprise) }

  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end


  describe 'GET#new' do
    login_user_from_let
    it 'returns success' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET#edit' do
    it 'returns success' do
      user.invite!

      get :edit, invitation_token: user.raw_invitation_token
      expect(response).to be_success
    end
  end

  describe 'PATCH#update' do
    it 'returns success' do
      invited = create(:user, enterprise: user.enterprise)
      invited.invite!

      xhr :patch, :update, { user: { 'password' => 'password', 'password_confirmation' => 'password', 'invitation_token' => invited.raw_invitation_token, 'first_name' => 'Another', 'last_name' => 'Test' } }
      expect(response).to redirect_to user_root_path
    end
  end

  describe 'POST#create' do
    login_user_from_let

    it 'renders new template' do
      post :create
      expect(response).to render_template :new
    end

    context 'with valid params' do
      params = {
          'user' => {
              'email' => 'johnsmith@diverst.com',
              'first_name' => 'John',
              'last_name' => 'Smith',
              'user_role_id' => '1'
          },
          'commit' => 'Send an invitation'
      }

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { post :create, params }
            .to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { User.last }
          let(:owner) { user }
          let(:key) { 'user.create' }

          before {
            perform_enqueued_jobs do
              post :create, params
            end
          }

          include_examples 'correct public activity'
        end
      end
    end
  end
end
