require 'rails_helper'

RSpec.describe EmailsController, type: :controller do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }

  describe 'GET#index' do
    context 'with logged in user' do
      login_user_from_let
      before { get :index }

      it 'render index template' do
        expect(response).to render_template :index
      end

      it 'return enterprise of current user' do
        expect(assigns[:enterprise]).to eq user.enterprise
      end

      it 'returns emails belonging to enterprise' do
        2.times { create(:email, enterprise: enterprise) }
        expect(assigns[:enterprise].emails.count).to eq 2
      end
    end

    context 'without a logged in user' do
      before { get :index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#new_custom' do
    context 'with logged in user' do
      login_user_from_let
      before { get :new_custom }

      it 'render correct template' do
        expect(response).to render_template :new_custom
      end

      it 'return enterprise of current user' do
        expect(assigns[:enterprise]).to eq user.enterprise
      end

      it 'returns customemails belonging to enterprise' do
        2.times { create(:custom_email, enterprise: enterprise) }
        expect(assigns[:enterprise].custom_emails.count).to eq 2
      end
    end

    context 'without a logged in user' do
      before { get :index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#update' do
    let(:email) { create(:email, enterprise: enterprise) }

    describe 'with logged in user' do
      login_user_from_let

      context 'with valid parameters' do
        before { patch :update, id: email.id, email: { subject: 'updated' } }

        it 'updates the email' do
          email.reload
          expect(email.subject).to eq 'updated'
        end

        it 'redirects to action index' do
          expect(response).to redirect_to action: :index
        end

        it 'flashes a notice message' do
          expect(flash[:notice]).to eq 'Your email was updated'
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { patch :update, id: email.id, email: { subject: 'updated' } }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { Email.last }
            let(:owner) { user }
            let(:key) { 'email.update' }

            before {
              perform_enqueued_jobs do
                patch :update, id: email.id, email: { subject: 'updated' }
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'with invalid parameters' do
        before { patch :update, id: email.id, email: { subject: nil } }

        it 'flashes an alert message' do
          email.reload
          expect(flash[:alert]).to eq 'Your email was not updated. Please fix the errors'
        end

        it 'renders edit template' do
          expect(response).to render_template :edit
        end
      end
    end

    describe 'without a logged in user' do
      before { patch :update, id: email.id, email: { subject: 'updated' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
