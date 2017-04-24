require 'rails_helper'

RSpec.describe BudgetsController, type: :controller do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group, enterprise: user.enterprise) }
  let!(:budget) { FactoryGirl.create(:approved_budget, subject: group) }

  describe 'GET#show' do
    context 'with logged user' do
      login_user_from_let

      before { get :show, group_id: budget.subject.id, id: budget.id }

      it 'return success' do
        expect(response).to be_success
      end
    end

    context 'without logged user' do
      before { get :show, group_id: budget.subject.id, id: budget.id }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'GET#edit_annual_budget' do
    let(:user) { create :user }
    let(:group) { create :group, enterprise: user.enterprise }

    def get_edit_annual_budget(group_id=-1)
      get :edit_annual_budget, group_id: group_id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_edit_annual_budget(group.id) }

      it 'return success' do
        expect(response).to be_success
      end
    end

    context 'without logged user' do
      before { get_edit_annual_budget }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'GET#new' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:group) { FactoryGirl.create(:group, enterprise: user.enterprise) }

    context 'with logged user' do
      login_user_from_let

      before { get :new, group_id: group.id }

      it 'return success' do
        expect(response).to be_success
      end
    end

    context 'without logged user' do
      before { get :new, group_id: group.id }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'POST#create' do
    context 'with logged user' do
      login_user_from_let

      context 'with correct params' do
        let(:budget_params) { FactoryGirl.attributes_for(:budget) }

        it 'redirects to correct action' do
          post :create, group_id: group.id, budget: budget_params

          expect(response).to redirect_to action: :index
        end

        it 'creates new budget' do
          expect{
            post :create, group_id: group.id, budget: budget_params
          }.to change(Budget,:count).by(1)
        end
      end
    end

    context 'without logged user' do
      before { post :create, group_id: group.id, budget: {} }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'POST #update_annual_budget' do
    def post_update_annual_budget(group_id = -1, params = {})
      post :update_annual_budget, group_id: group_id, group: params
    end

    let(:user) { create :user }
    let(:group) { create :group, enterprise: user.enterprise, annual_budget: annual_budget }

    let(:annual_budget) { rand(1..100) }
    let(:new_annual_budget) { rand(101..200) } #new range so it does not intersect with old value range

    context 'with logged in user' do
      login_user_from_let

      context 'with correct parsms' do
        before do
          post_update_annual_budget(group.id, {annual_budget: new_annual_budget})
        end

        it 'updates group annual budget' do
          expect(group.reload.annual_budget).to eq new_annual_budget
        end

        it 'redirects to correct path' do
          expect(response).to redirect_to edit_annual_budget_group_budgets_path(group.enterprise)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            expect{
              post_update_annual_budget(group.id, {annual_budget: new_annual_budget})
            }.to change(PublicActivity::Activity, :count).by(1)
          end

          describe 'activity record' do
            let(:model) { Group.last }
            let(:owner) { user }
            let(:key) { 'group.annual_budget_update' }

            before {
              post_update_annual_budget(group.id, {annual_budget: new_annual_budget})
            }

            include_examples'correct public activity'
          end
        end
      end
    end

    context 'without logged user' do
      before { post_update_annual_budget(group.id, {annual_budget: new_annual_budget}) }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'DELETE#destroy' do
    context 'with logged user' do
      login_user_from_let

      it 'removes a budget' do
        expect{ delete :destroy, group_id: budget.subject.id, id: budget.id }.to change(Budget, :count).by(-1)
      end

      it 'redirects to index action' do
        delete :destroy, group_id: budget.subject.id, id: budget.id
        expect(response).to redirect_to action: :index
      end
    end
  end
end
