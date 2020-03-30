require 'rails_helper'

RSpec.describe EnterprisesController, type: :controller do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }

  describe 'GET#edit' do
    describe 'with logged in user' do
      login_user_from_let

      context 'with valid id' do
        before { get :edit, id: enterprise.id }

        it 'returns edit template' do
          expect(response).to render_template :edit
        end

        it 'returns a valid enterprise object' do
          expect(assigns[:enterprise]).to be_valid
        end
      end
    end

    describe 'without a logged in user' do
      before { get :edit, id: enterprise.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#update' do
    describe 'with logged in user' do
      before { request.env['HTTP_REFERER'] = 'back' }
      login_user_from_let

      let!(:attributes) { attributes_for(:enterprise,
                                         home_message: 'updated',
                                         time_zone: 'Eastern Time (US & Canada)',
                                         disable_likes: true,
                                         default_from_email_address: 'tech@diverst.com',
                                         default_from_email_display_name: 'DIVERST',
                                         enable_social_media: true,
                                         plan_module_enabled: true,
                                         mentorship_module_enabled: true,
                                         enable_rewards: true,
                                         enable_pending_comments: true)
      }
      context 'with valid parameters' do
        before { patch :update, id: enterprise.id, enterprise: attributes }

        it 'updates the enterprise' do
          enterprise.reload
          expect(assigns[:enterprise].home_message).to eq 'updated'
          expect(assigns[:enterprise].time_zone).to eq 'Eastern Time (US & Canada)'
          expect(assigns[:enterprise].disable_likes).to be true
          expect(assigns[:enterprise].default_from_email_address).to eq 'tech@diverst.com'
          expect(assigns[:enterprise].default_from_email_display_name).to eq 'DIVERST'
          expect(assigns[:enterprise].enable_social_media).to be true
          expect(assigns[:enterprise].plan_module_enabled).to be true
          expect(assigns[:enterprise].mentorship_module_enabled).to be true
          expect(assigns[:enterprise].enable_pending_comments).to be true
          expect(assigns[:enterprise].enable_rewards).to be true
        end

        it 'redirects to action index' do
          expect(response).to redirect_to 'back'
        end

        it 'flashes notice a message' do
          expect(flash[:notice]).to eq 'Your enterprise was updated'
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { patch :update, id: enterprise.id, enterprise: attributes }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { enterprise }
            let(:owner) { user }
            let(:key) { 'enterprise.update' }

            before {
              perform_enqueued_jobs do
                patch :update, id: enterprise.id, enterprise: attributes
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'with invalid parameters', skip: "render params['source'] causes ActionView::MissingTemplate" do
        before { patch :update, id: enterprise.id, enterprise: { home_message: '' } }

        it 'does not update the enterprise' do
          enterprise.reload
          expect(enterprise.home_message).to eq 'test'
        end

        it 'renders action edit' do
          expect(response.status).to eq(302)
        end

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your enterprise was not updated. Please fix the errors'
        end
      end
    end

    describe 'without a logged in user' do
      before { patch :update, id: enterprise.id, enterprise: attributes_for(:enterprise, home_message: 'updated') }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#update_posts' do
    describe 'with logged in user' do
      before { request.env['HTTP_REFERER'] = 'back' }
      login_user_from_let
      let!(:attributes) { attributes_for(:enterprise, home_message: 'updated') }

      context 'with valid parameters' do
        before { patch :update_posts, id: enterprise.id, enterprise: attributes }

        it 'updates the enterprise' do
          enterprise.reload
          expect(assigns[:enterprise].home_message).to eq 'updated'
        end

        it 'redirects to action index' do
          expect(response).to redirect_to 'back'
        end

        it 'flashes notice a message' do
          expect(flash[:notice]).to eq 'Your enterprise was updated'
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { patch :update_posts, id: enterprise.id, enterprise: attributes }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { enterprise }
            let(:owner) { user }
            let(:key) { 'enterprise.update' }

            before {
              perform_enqueued_jobs do
                patch :update_posts, id: enterprise.id, enterprise: attributes
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'with invalid parameters', skip: "render params['source'] causes ActionView::MissingTemplate" do
        before { patch :update_posts, id: enterprise.id, enterprise: { home_message: '' } }

        it 'does not update the enterprise' do
          enterprise.reload
          expect(enterprise.home_message).to eq 'test'
        end

        it 'renders action edit' do
          expect(response.status).to eq(302)
        end

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your enterprise was not updated. Please fix the errors'
        end
      end
    end

    describe 'without a logged in user' do
      before { patch :update_posts, id: enterprise.id, enterprise: attributes_for(:enterprise, home_message: 'updated') }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#edit_fields' do
    describe 'with logged in user' do
      login_user_from_let

      context 'with valid id' do
        before { get :edit_fields, id: enterprise.id }

        it 'renders edit_fields template' do
          expect(response).to render_template :edit_fields
        end

        it 'returns a valid enterprise object' do
          expect(assigns[:enterprise]).to be_valid
        end
      end
    end

    describe 'without a logged in user' do
      before { get :edit_fields, id: enterprise.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#edit_budgeting' do
    describe 'with logged in user' do
      login_user_from_let

      context 'with valid id' do
        before { get :edit_budgeting, id: enterprise.id }

        it 'renders edit_budgeting template' do
          expect(response).to render_template :edit_budgeting
        end

        it 'returns a valid enterprise object' do
          expect(assigns[:enterprise]).to be_valid
        end

        it 'returns groups belonging to valid enterprise object' do
          expect(assigns[:groups]).to eq enterprise.groups
        end
      end
    end

    describe 'without a logged in user' do
      before { get :edit_budgeting, id: enterprise.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  # CONTROLLER IS MISSING A TEMPLATE

  describe 'GET#edit_cdo', skip: "tests fails because no route matches action: 'edit_cdo" do
    describe 'with logged in user' do
      login_user_from_let

      context 'with valid id' do
        before { get :edit_cdo, id: enterprise.id }

        it 'returns success' do
          expect(response).to be_success
        end
      end
    end
  end

  # CONTROLLER IS MISSING A TEMPLATE

  describe 'GET#edit_mobile_fields', skip: 'test fails because of Missing template layouts/handshake...' do
    describe 'with logged in user' do
      login_user_from_let

      context 'with valid id' do
        before { get :edit_mobile_fields, id: enterprise.id }

        it 'render edit_mobile_fields template' do
          expect(response).to render_template :edit_mobile_fields
        end
      end
    end

    describe 'without a logged in user' do
      before { get :edit_mobile_fields, id: enterprise.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#edit_auth' do
    describe 'with logged in user' do
      login_user_from_let

      context 'with valid id' do
        before { get :edit_auth, id: enterprise.id }

        it 'render edit_auth template' do
          expect(response).to render_template :edit_auth
        end

        it 'returns a valid enterprise object' do
          expect(assigns[:enterprise]).to be_valid
        end
      end
    end

    describe 'without a logged in user' do
      before { get :edit_auth, id: enterprise.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#edit_branding' do
    describe 'with logged in user' do
      login_user_from_let

      context 'with valid id' do
        it 'render edit_branding template' do
          get :edit_branding, id: enterprise.id
          expect(response).to render_template :edit_branding
        end

        it 'returns a valid enterprise object' do
          get :edit_branding, id: enterprise.id
          expect(assigns[:enterprise]).to be_valid
        end

        context 'when enterprise has no theme' do
          it 'returns a new theme object from set_theme' do
            get :edit_branding, id: enterprise.id
            expect(assigns[:theme]).to be_a_new(Theme)
          end
        end

        context 'when enterprise has a theme' do
          before { enterprise.update(theme: create(:theme)) }

          it 'returns a valid theme object from set_theme' do
            get :edit_branding, id: enterprise.id
            expect(assigns[:enterprise].theme).to be_valid
          end
        end
      end
    end

    describe 'without a logged in user' do
      before { get :edit_branding, id: enterprise.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#edit_algo' do
    describe 'with logged in user' do
      login_user_from_let

      context 'with valid id' do
        before { get :edit_algo, id: enterprise.id }

        it 'render edit_algo template' do
          expect(response).to render_template :edit_algo
        end
      end
    end

    describe 'without a logged in user' do
      before { get :edit_algo, id: enterprise.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#update_branding' do
    describe 'with logged in user' do
      login_user_from_let

      context 'with valid attributes' do
        before {
          perform_enqueued_jobs do
            patch :update_branding, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: { primary_color: '#ff0000' })
          end
        }

        it 'returns a valid theme object from set_theme' do
          expect(assigns[:theme]).to be_a_new(Theme)
        end

        it 'redirect_to edit_branding' do
          expect(response).to redirect_to action: :edit_branding
        end

        it 'flashes a notice message' do
          expect(flash[:notice]).to eq 'Enterprise branding was updated'
        end

        it 'update was successful' do
          enterprise.reload
          expect(enterprise.theme.primary_color).to eq '#ff0000'
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { patch :update_branding, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: { primary_color: '#ff0000' }) }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { enterprise }
            let(:owner) { user }
            let(:key) { 'enterprise.update_branding' }

            before {
              perform_enqueued_jobs do
                patch :update_branding, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: { primary_color: '#ff0000' })
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'with invalid attributes' do
        before { patch :update_branding, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: { primary_color: 'red' }) }

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Enterprise branding was not updated. Please fix the errors'
        end

        it 'render edit_branding template' do
          expect(response).to render_template :edit_branding
        end
      end
    end

    describe 'without a logged in user' do
      before { patch :update_branding, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: { primary_color: '#ff0000' }) }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#delete_attachment' do
    before { request.env['HTTP_REFERER'] = 'back' }

    describe 'with logged in user' do
      login_user_from_let

      context 'with valid attributes' do
        before { patch :delete_attachment, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: { primary_color: '#ff0000' }) }

        it 'redirect_to back' do
          expect(response).to redirect_to 'back'
        end

        it 'flashes a notice message' do
          expect(flash[:notice]).to eq 'Enterprise attachment was removed'
        end
      end

      context 'with invalid attributes' do
        before do
          allow_any_instance_of(Enterprise).to receive(:save).and_return(false)
          patch :delete_attachment, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: { primary_color: nil })
        end

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Enterprise attachment was not removed. Please fix the errors'
        end
      end
    end

    describe 'without a logged in user' do
      before { patch :delete_attachment, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: { primary_color: '#ff0000' }) }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#restore_default_branding' do
    before { request.env['HTTP_REFERER'] = 'back' }

    describe 'with logged in user' do
      login_user_from_let

      context 'with valid attributes' do
        before { patch :restore_default_branding, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: { logo_file_name: 'test' }) }

        it 'redirect_to back' do
          expect(response).to redirect_to 'back'
        end

        it 'returns a valid enterprise objec' do
          expect(assigns[:enterprise]).to be_valid
        end
      end
    end

    describe 'without a logged in user' do
      before { patch :restore_default_branding, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: { logo_file_name: 'test' }) }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#calendar' do
    it 'allows view to be embed on iframe' do
      get :calendar, id: enterprise.id
      expect(response.headers).to_not include('X-Frame-Options')
    end

    it 'assigns enterprise to @enterprise' do
      get :calendar, id: enterprise.id
      expect(assigns(:enterprise)).to eq enterprise
    end

    it 'expect no layout' do
      expect(response).to render_template(layout: false)
    end
  end

  describe 'PATCH#auto_archive_switch' do
    context 'when user is logged in' do
      login_user_from_let

      before do
        enterprise.update(expiry_age_for_resources: 1)
        xhr :patch, :auto_archive_switch, id: enterprise.id, format: :js
      end

      it 'switch auto_archive ON for enterprise' do
        expect(assigns[:enterprise].auto_archive).to eq true
      end

      it 'renders nothing' do
        expect(response).to render_template(nil)
      end
    end
  end

  describe 'PATCH#enable_onboarding_consent' do
    context 'when user is logged in' do
      login_user_from_let

      before { xhr :patch, :enable_onboarding_consent, id: enterprise.id, format: :js }

      it 'enable onboarding consent' do
        expect(assigns[:enterprise].onboarding_consent_enabled).to eq(true)
      end

      it 'renders nothing' do
        expect(response).to render_template(nil)
      end
    end
  end
end
