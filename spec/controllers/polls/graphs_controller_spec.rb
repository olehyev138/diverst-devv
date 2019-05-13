require 'rails_helper'

RSpec.describe Polls::GraphsController, type: :controller do
  let(:user) { create :user }
  let(:poll) { create(:poll, enterprise: user.enterprise) }
  let(:field) { create(:field, type: 'NumericField') }


  describe 'GET#new' do
    describe 'when user is logged in' do
      login_user_from_let
      before { get :new, poll_id: poll.id }

      it 'renders new template' do
        expect(response).to render_template :new
      end

      it 'returns a new graph' do
        expect(assigns[:graph]).to be_a_new(Graph)
      end
    end

    describe 'when user is not logged in' do
      before { get :new, poll_id: poll.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'POST#create' do
    describe 'when user is logged in' do
      login_user_from_let

      context 'with valid params' do
        it 'creates a graph object' do
          expect { post :create, poll_id: poll.id, graph: { field_id: field.id } }.to change(Graph, :count).by(2)
        end

        it 'flashes a notice message' do
          post :create, poll_id: poll.id, graph: { field_id: field.id }
          expect(flash[:notice]).to eq 'Your graph was created'
        end

        it 'redirects' do
          post :create, poll_id: poll.id, graph: { field_id: field.id }
          expect(response).to redirect_to(poll)
        end
      end

      context 'with invalid params' do
        it 'valid graph object not created' do
          expect { post :create, poll_id: poll.id, graph: { field_id: nil } }.to change(Graph, :count).by(1)
        end

        it 'flashes an alert message' do
          post :create, poll_id: poll.id, graph: { field_id: nil }
          expect(flash[:alert]).to eq 'Your graph was not created. Please fix the errors'
        end

        it 'renders new template' do
          post :create, poll_id: poll.id, graph: { field_id: nil }
          expect(response).to render_template :new
        end
      end
    end

    describe 'when user is not logged in' do
      before { post :create, poll_id: poll.id, graph: { field_id: field.id } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
