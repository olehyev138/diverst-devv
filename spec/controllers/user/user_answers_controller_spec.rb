require 'rails_helper'
require 'spec_helper'

RSpec.describe User::UserAnswersController, type: :controller do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise, enable_rewards: true) }
  let(:user) { create :user, enterprise: enterprise }

  describe 'PUT#vote' do
    let!(:answer) { create(:answer, question: create(:question, campaign: create(:campaign, users: [user]))) }
    let!(:reward_action) { create(:reward_action, enterprise: user.enterprise, key: 'campaign_vote', points: 70) }

    describe 'when user is logged in' do
      login_user_from_let

      context 'when voting an answer' do
        it 'rewards a user with points of this action' do
          expect(user.points).to eq 0

          put :vote, id: answer.id, answer: { upvoted: 'true' }

          user.reload
          expect(user.points).to eq 70
        end

        it 'flash a reward message' do
          put :vote, id: answer.id, answer: { upvoted: 'true' }
          user.reload
          expect(flash[:reward]).to eq "Now you have #{user.credits} points"
        end

        it 'render partial' do
          put :vote, id: answer.id, answer: { upvoted: 'true' }
          user.reload
          expect(response).to render_template('partials/flash_messages.js')
        end

        it 'destroy vote if vote_params[:upvoted] is not true' do
          put :vote, id: answer.id, answer: { upvoted: 'false' }
          user.reload
          expect(AnswerUpvote.count).to eq 0
        end
      end
    end

    describe 'when user is not logged in' do
      before { put :vote, id: answer.id, answer: { upvoted: 'true' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'POST#create' do
    let(:question) { create(:question, campaign: create(:campaign, enterprise: user.enterprise)) }
    let(:group) { create(:group) }
    let!(:reward_action) { create(:reward_action, enterprise: user.enterprise, key: 'campaign_answer', points: 75) }

    describe 'with logged in user' do
      login_user_from_let

      context 'successfully create answer' do
        it 'creates answer object' do
          expect { post :create, question_id: question.id, answer: { contributing_group_id: group.id, content: "Here's some content for you" } }
            .to change(Answer, :count).by(1)
        end

        it 'rewards a user with points of this action' do
          expect(user.points).to eq 0

          post :create, question_id: question.id, answer: { contributing_group_id: group.id, content: "Here's some content for you" }

          user.reload
          expect(user.points).to eq 75
        end

        it 'flashes a reward message' do
          post :create, question_id: question.id, answer: { contributing_group_id: group.id, content: "Here's some content for you" }
          user.reload
          expect(flash[:reward]).to eq "Your answer was created. Now you have #{user.credits} points"
        end

        it 'redirects to campaign question' do
          post :create, question_id: question.id, answer: { contributing_group_id: group.id, content: "Here's some content for you" }
          expect(response).to redirect_to [:user, question ]
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { post :create, question_id: question.id, answer: { contributing_group_id: group.id, content: "Here's some content for you" } }
                .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { Answer.last }
            let(:owner) { user }
            let(:key) { 'answer.create' }

            before {
              perform_enqueued_jobs do
                post :create, question_id: question.id, answer: { contributing_group_id: group.id, content: "Here's some content for you" }
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'failed answer creation' do
        before { post :create, question_id: question.id, answer: { content: nil } }

        it 'flashes an alert messsage' do
          expect(flash[:alert]).to eq 'Your answer was not created. Please fix the errors'
        end

        it 'redirects to campaign question' do
          post :create, question_id: question.id, answer: { content: nil }
          expect(response).to redirect_to [:user, question ]
        end
      end
    end

    describe 'when user is not logged in' do
      before { post :create, question_id: question.id, answer: { content: "Here's some content for you" } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
