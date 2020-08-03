require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }

  describe 'PUT#update' do
    let!(:answer) { create(:answer, chosen: false, question: create(:question, campaign: create(:campaign, enterprise: enterprise, users: [user]))) }

    describe 'when user is logged in' do
      login_user_from_let

      context 'when choosing an answer to proceed with' do
        it 'is successful' do
          expect(answer.chosen).to eq(false)

          xhr :put, :update, id: answer.id, answer: { chosen: 'true' }, format: :json

          answer.reload
          expect(answer.chosen).to eq(true)
        end

        it 'renders nothing' do
          xhr :put, :update, id: answer.id, answer: { chosen: true }, format: :json
          expect(response).to render_template(nil)
        end
      end
    end
  end
end
