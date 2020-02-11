require 'rails_helper'
require 'spec_helper'

RSpec.describe User::UserAnswerCommentsController, type: :controller do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise, enable_rewards: true) }
  let(:user) { create :user, enterprise: enterprise }

  describe 'POST#create' do
    let(:answer) { create(:answer, question: create(:question, campaign: create(:campaign, users: [user]))) }
    let!(:reward_action) { create(:reward_action, enterprise: user.enterprise, key: 'campaign_comment', points: 50) }

    describe 'when user is logged in' do
      login_user_from_let

      context 'successfully create comment' do
        it 'rewards a user with points of this action' do
          expect(user.points).to eq 0

          post :create, user_answer_id: answer.id, answer_comment: { content: 'blah' }

          user.reload
          expect(user.points).to eq 50
        end

        it 'create comment object' do
          expect { post :create, user_answer_id: answer.id, answer_comment: { content: 'blah' } }.to change(AnswerComment, :count).by(1)
        end

        it 'flash reward message' do
          post :create, user_answer_id: answer.id, answer_comment: { content: 'blah' }
          user.reload
          expect(flash[:reward]).to eq "Your comment was created. Now you have #{user.credits} points"
        end

        it 'redirects to question' do
          post :create, user_answer_id: answer.id, answer_comment: { content: 'blah' }
          expect(response).to redirect_to [:user, answer.question]
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { post :create, user_answer_id: answer.id, answer_comment: { content: 'blah' } }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { AnswerComment.last }
            let(:owner) { user }
            let(:key) { 'answer_comment.create' }

            before {
              perform_enqueued_jobs do
                post :create, user_answer_id: answer.id, answer_comment: { content: 'blah' }
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'comment create failed' do
        before { post :create, user_answer_id: answer.id, answer_comment: { content: nil } }

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your comment was not created. Please fix the errors'
        end

        it 'redirects to question' do
          post :create, user_answer_id: answer.id, answer_comment: { content: nil }
          expect(response).to redirect_to [:user, answer.question]
        end
      end
    end

    describe 'when users is not logged in' do
      before { post :create, user_answer_id: answer.id, answer_comment: { content: 'blah' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
