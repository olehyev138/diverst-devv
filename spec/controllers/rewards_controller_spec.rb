require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  include ActiveJob::TestHelper

  let!(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }
  let!(:reward) { create(:reward, enterprise: enterprise, points: 10) }
  let!(:badge) { create(:badge, enterprise: enterprise) }

  describe 'GET#index' do
    context 'with logged in user' do
      login_user_from_let

      before { get :index }

      it 'gets the rewards' do
        expect(assigns[:rewards]).to eq [reward]
      end

      it 'gets the badges' do
        expect(assigns[:badges]).to eq [badge]
      end

      it 'renders index template' do
        expect(response).to render_template :index
      end

      it 'sets a valid enterprise object' do
        expect(assigns[:enterprise]).to be_valid
      end
    end

    context 'without a logged in user' do
      before { get :index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET#new' do
    context 'with logged in user' do
      login_user_from_let
      before { get :new }

      it 'gets the new page' do
        expect(response).to render_template :new
      end

      it 'returns a valid enterprise object' do
        expect(assigns[:enterprise]).to be_valid
      end

      it 'returns a new reward object' do
        expect(assigns[:reward]).to be_a_new(Reward)
      end
    end

    context 'without a logged in user' do
      before { get :new }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'POST#create' do
    describe 'with logged in user' do
      login_user_from_let

      context 'with valid parameters' do
        it 'creates a new reward' do
          expect { post :create, reward: attributes_for(:reward).merge(responsible_id: user.id) }.to change(enterprise.rewards, :count).by(1)
        end

        it 'flashes a notice message' do
          post :create, reward: attributes_for(:reward).merge(responsible_id: user.id)
          expect(flash[:notice]).to eq 'Your reward was created'
        end

        it 'redirects to action index' do
          post :create, reward: attributes_for(:reward).merge(responsible_id: user.id)
          expect(response).to redirect_to(action: :index)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect {
                post :create, reward: attributes_for(:reward).merge(responsible_id: user.id)
              }.to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { Reward.last }
            let(:owner) { user }
            let(:key) { 'reward.create' }

            before {
              perform_enqueued_jobs do
                post :create, reward: attributes_for(:reward).merge(responsible_id: user.id)
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new reward' do
          expect { post :create, reward: attributes_for(:reward, label: '') }.to_not change(enterprise.rewards, :count)
        end

        it 'renders action new' do
          post :create, reward: attributes_for(:reward, label: '')
          expect(response).to render_template :new
        end

        it 'flashes an alert message' do
          post :create, reward: attributes_for(:reward, label: '')
          expect(flash[:alert]).to eq 'Your reward was not created. Please fix the errors'
        end
      end
    end

    describe 'without a logged in user' do
      before { post :create, reward: attributes_for(:reward).merge(responsible_id: user.id) }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET#edit' do
    describe 'with logged in user' do
      login_user_from_let
      before { get :edit, id: reward.id }

      it 'gets the edit page' do
        expect(response).to render_template :edit
      end

      it 'returns a valid enterprise object' do
        expect(assigns[:enterprise]).to be_valid
      end

      it 'returns a valid reward object' do
        expect(assigns[:reward]).to be_valid
      end

      it 'returns reward object belonging to enterprise' do
        expect(assigns[:reward].enterprise).to eq enterprise
      end
    end

    describe 'without a logged in user' do
      before { get :edit, id: reward.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'PATCH#update' do
    let(:reward) { create(:reward, enterprise: enterprise, points: 10) }

    describe 'with logged in user' do
      login_user_from_let

      context 'with valid parameters' do
        before(:each) { patch :update, id: reward.id, reward: attributes_for(:reward, points: 20) }

        it 'updates the reward' do
          reward.reload
          expect(reward.points).to eq 20
        end

        it 'redirects to action index' do
          expect(response).to redirect_to(action: :index)
        end

        it 'flashes a notice message' do
          expect(flash[:notice]).to eq 'Your reward was updated'
        end
      end

      context 'with invalid parameters' do
        before(:each) { patch :update, id: reward.id, reward: attributes_for(:reward, points: '') }

        it 'does not update the reward' do
          reward.reload
          expect(reward.points).to eq 10
        end

        it 'renders action edit' do
          expect(response).to render_template :edit
        end

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your reward was not updated. Please fix the errors'
        end
      end
    end

    describe 'without a logged in user' do
      before { patch :update, id: reward.id, reward: attributes_for(:reward, points: '') }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'DELETE#destroy' do
    describe 'with logged in user' do
      login_user_from_let
      let!(:reward) { create(:reward, enterprise: enterprise) }

      it 'destroy the reward' do
        expect { delete :destroy, id: reward.id }.to change(enterprise.rewards, :count).by(-1)
      end

      it 'redirects to action index' do
        delete :destroy, id: reward.id
        expect(response).to redirect_to(action: :index)
      end

      it 'flahses a notice message' do
        delete :destroy, id: reward.id
        expect(flash[:notice]).to eq 'Your reward was deleted'
      end
    end

    describe 'without a logged in user' do
      before { delete :destroy, id: reward.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
