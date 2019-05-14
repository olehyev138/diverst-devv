require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }
  let(:campaign) { create(:campaign, enterprise: user.enterprise) }
  let(:question) { create(:question, campaign: campaign) }

  describe 'GET#index' do
    context 'with logged user' do
      login_user_from_let
      before { get :index, campaign_id: campaign.id }

      it 'gets the index' do
        expect(response).to render_template :index
      end

      it 'returns a valid campaign object' do
        expect(assigns[:campaign]).to be_valid
      end

      it 'list campaign questions in descending order by created_at' do
        question
        question1 = create(:question, campaign: campaign, created_at: Time.now - 5.hours, updated_at: Time.now - 5.hours)
        question2 = create(:question, campaign: campaign, created_at: Time.now - 2.hours, updated_at: Time.now - 2.hours)

        expect(assigns[:questions]).to eq [question, question2, question1]
      end
    end

    context 'without a logged in user' do
      before { get :index, campaign_id: campaign.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET#new' do
    context 'with logged user' do
      login_user_from_let
      before { get :new, campaign_id: campaign.id }

      it 'gets the new page' do
        expect(response).to render_template :new
      end

      it 'returns a valid campaign object' do
        expect(assigns[:question].campaign).to be_valid
      end

      it 'returns a new question object' do
        expect(assigns[:question]).to be_a_new(Question)
      end
    end

    context 'without a logged in user' do
      before { get :new, campaign_id: campaign.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET#show' do
    context 'with logged user' do
      let!(:answer1) { create(:answer, question: question, upvote_count: 2) }
      let!(:answer2) { create(:answer, question: question, upvote_count: 5) }
      login_user_from_let
      before { get :show, id: question.id }

      it 'gets the show page' do
        expect(response).to render_template :show
      end

      it 'returns a valid campaign object' do
        expect(assigns[:question].campaign).to be_valid
      end

      it 'return answers belonging to a question in descending order of upvote_count' do
        expect(assigns[:answers]).to eq [answer2, answer1]
      end
    end

    context 'without a logged in user' do
      before { get :show, id: question.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'POST#create' do
    context 'with logged user' do
      login_user_from_let

      context 'when successful' do
        it 'redirects to index action' do
          post :create, campaign_id: campaign.id, question: { title: 'Title', description: 'description' }
          expect(response).to redirect_to action: :index
        end

        it 'creates the question object' do
          campaign.reload
          expect { post :create, campaign_id: campaign.id, question: { title: 'Title', description: 'description' } }
          .to change(Question, :count).by(1)
        end

        it 'flashes a notice message' do
          post :create, campaign_id: campaign.id, question: { title: 'Title', description: 'description' }
          expect(flash[:notice]).to eq 'Your question was created'
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { post :create, campaign_id: campaign.id, question: { title: 'Title', description: 'description' } }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { Question.last }
            let(:owner) { user }
            let(:key) { 'question.create' }

            before {
              perform_enqueued_jobs do
                post :create, campaign_id: campaign.id, question: { title: 'Title', description: 'description' }
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'when unsuccessful' do
        it 'renders new' do
          post :create, campaign_id: campaign.id, question: { title: nil, description: 'description' }
          expect(response).to render_template :new
        end

        it 'does not create the question object' do
          campaign.reload
          expect { post :create, campaign_id: campaign.id, question: { title: nil, description: 'description' } }
          .to change(Question, :count).by(0)
        end

        it 'flashes an alert message' do
          post :create, campaign_id: campaign.id, question: { title: nil, description: 'description' }
          expect(flash[:alert]).to eq 'Your question was not created. Please fix the errors'
        end
      end
    end

    context 'without a logged in user' do
      before { post :create, campaign_id: campaign.id, question: { title: 'Title', description: 'description' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'PATCH#reopen' do
    context 'with logged user' do
      login_user_from_let
      before do
        request.env['HTTP_REFERER'] = 'back'
        patch :reopen, id: question.id
      end

      it 'gets the show page' do
        expect(response).to redirect_to 'back'
      end

      it 'reopens the question' do
        expect(assigns[:question].solved_at).to be_nil
      end
    end

    context 'without a logged in user' do
      before do
        request.env['HTTP_REFERER'] = 'back'
        patch :reopen, id: question.id
      end
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET#edit' do
    context 'with logged user' do
      login_user_from_let
      before { get :edit, id: question.id }

      it 'gets the edit page' do
        expect(response).to render_template :edit
      end

      it 'returns a valid question object' do
        expect(assigns[:question]).to be_valid
      end
    end

    context 'without a logged in user' do
      before { get :edit, id: question.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'PATCH#update' do
    describe 'with logged user' do
      login_user_from_let

      context 'when successful' do
        before { patch :update, id: question.id, question: { title: 'updated' } }

        it 'redirects to the question' do
          expect(response).to redirect_to(question)
        end

        it 'updates question title' do
          question.reload
          expect(question.title).to eq('updated')
        end

        it 'flashes a notice message' do
          expect(flash[:notice]).to eq 'Your question was updated'
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { patch :update, id: question.id, question: { title: 'updated' } }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { question }
            let(:owner) { user }
            let(:key) { 'question.update' }

            before {
              perform_enqueued_jobs do
                patch :update, id: question.id, question: { title: 'updated' }
              end
            }

            include_examples 'correct public activity'
          end
        end
      end
      context 'when unsuccessful' do
        before { patch :update, id: question.id, question: { title: nil } }

        it 'redirects to the question' do
          expect(response).to render_template :edit
        end

        it 'does not update the question' do
          question.reload
          expect(question.title).to_not eq('updated')
        end

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq('Your question was not updated. Please fix the errors')
        end
      end
    end

    describe 'without a logged in user' do
      before { patch :update, id: question.id, question: { title: 'updated' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'DELETE#destroy' do
    context 'with logged user' do
      login_user_from_let

      before { request.env['HTTP_REFERER'] = 'back' }

      it 'redirects to previous page' do
        delete :destroy, id: question.id
        expect(response).to redirect_to 'back'
      end

      it 'deletes the question' do
        question
        expect { delete :destroy, id: question.id }
        .to change(Question, :count).by(-1)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { delete :destroy, id: question.id }
            .to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { question }
          let(:owner) { user }
          let(:key) { 'question.destroy' }

          before {
            perform_enqueued_jobs do
              delete :destroy, id: question.id
            end
          }

          include_examples 'correct public activity'
        end
      end
    end

    context 'without a logged in user' do
      before { delete :destroy, id: question.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
