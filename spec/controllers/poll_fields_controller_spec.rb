require 'rails_helper'

RSpec.describe PollFieldsController, type: :controller do
  let(:enterprise) { create :enterprise }
  let(:user) { create :user, enterprise: enterprise }
  let(:poll) { create :poll }
  let(:field) { create :field, type: 'CheckboxField' }

  describe 'GET #answer_popularities' do
    context 'with logged user' do
      login_user_from_let

      before { get :answer_popularities, poll_id: poll.id, id: field.id }

      it 'renders a response in json' do
        expect(response.content_type).to eq 'application/json'
      end
    end

    context 'without a logged in user' do
      before { get :answer_popularities, poll_id: poll.id, id: field.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET #show' do
    context 'with logged user' do
      login_user_from_let

      before { get :show, poll_id: poll.id, id: field.id }

      it 'renders show template' do
        expect(response).to render_template :show
      end

      it 'returns response of a particular poll' do
        2.times { create(:poll_response, poll: poll) }
        expect(assigns[:responses].count).to eq 2
      end
    end

    context 'without a logged in user' do
      before { get :show, poll_id: poll.id, id: field.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
