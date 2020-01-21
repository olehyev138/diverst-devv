require 'rails_helper'

RSpec.describe CustomEmailsController, type: :controller do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }

  describe 'GET#new' do
    context 'with logged in user' do
      login_user_from_let
      before { get :new }

      it 'render correct template' do
        expect(response).to render_template :new
      end

      it 'return enterprise of current user' do
        expect(assigns[:enterprise]).to eq user.enterprise
      end

      it 'returns custom emails belonging to enterprise' do
        2.times { create(:custom_email, enterprise: enterprise) }
        expect(assigns[:enterprise].custom_emails.count).to eq 2
      end

      it 'sets submit url path correctly' do
        expect(assigns[:submit_url]).to eq custom_emails_path
        expect(assigns[:submit_method]).to eq 'post'
      end
    end

    context 'without a logged in user' do
      before { get :index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#edit' do
    let(:custom_email) { create :custom_email, enterprise: enterprise }

    context 'with logged in user' do
      login_user_from_let
      before { get :edit, id: custom_email.id }

      it 'render correct template' do
        expect(response).to render_template :edit
      end

      it 'assigns correct email' do
        expect(assigns[:custom_email]).to eq custom_email
      end

      it 'assigns correct submit path' do
        expect(assigns[:submit_url]).to eq custom_email_path(custom_email)
        expect(assigns[:submit_method]).to eq 'patch'
      end
    end

    context 'without a logged in user' do
      before { get :edit, id: custom_email.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST #create' do
    let(:params) { attributes_for :custom_email, enterprise: enterprise }

    def post_create(params = { a: 1 })
      post :create, email: params
    end

    describe 'with logged in user' do
      let(:user) { create :user }
      let(:email_attrs) { attributes_for :custom_email }

      login_user_from_let

      context 'with correct params' do
        it 'creates new email' do
          expect {
            post_create(email_attrs)
          }.to change(Email, :count).by(1)
        end

        it 'creates custom email' do
          post_create(email_attrs)
          expect(Email.last.custom?).to eq true
        end

        it 'flashes a notice message' do
          post_create(email_attrs)
          expect(flash[:notice]).to eq 'Your custom email was created'
        end

        it 'redirects to correct path' do
          post_create(email_attrs)
          expect(response).to redirect_to emails_path
        end
      end

      context 'with incorrect params' do
        it 'does not save the new email' do
          expect { post_create() }
            .to_not change(Email, :count)
        end

        it 'flashes an alert message' do
          post_create
          expect(flash[:alert]).to eq 'Your custom email was not created, please fix errors'
        end

        it 'renders new view' do
          post_create
          expect(response).to render_template :new
        end

        it 'shows error' do
          post_create
          custom_email = assigns(:custom_email)

          expect(custom_email.errors).to_not be_empty
        end
      end
    end

    describe 'without logged in user' do
      before { post_create }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#update' do
    let(:email) { create(:custom_email, enterprise: enterprise) }

    describe 'with logged in user' do
      login_user_from_let

      context 'with valid parameters' do
        before { patch :update, id: email.id, email: { subject: 'updated' } }

        it 'updates the email' do
          email.reload
          expect(email.subject).to eq 'updated'
        end

        it 'redirects to action index of Email Controller' do
          expect(response).to redirect_to emails_path
        end

        it 'flashes a notice message' do
          expect(flash[:notice]).to eq 'Your custom email was updated'
        end
      end

      context 'with invalid parameters' do
        before { patch :update, id: email.id, email: { subject: nil } }

        it 'flashes an alert message' do
          email.reload
          expect(flash[:alert]).to eq 'Your custom email was not updated. Please fix the errors'
        end

        it 'renders edit template for system email' do
          expect(response).to render_template :edit
        end
      end
    end

    describe 'without a logged in user' do
      before { patch :update, id: email.id, email: { subject: 'updated' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#de'
end
