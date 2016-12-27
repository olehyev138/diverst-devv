require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  describe 'GET #index' do
    def get_index
      get :index
    end

    context 'with logged user' do
      login_user

      before { get_index }

      it 'return success' do
        expect(response).to be_success
      end
    end

    context 'without logged user' do
      before { get_index }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'GET #settings' do
    let(:user) { create :user }
    let(:group) { create :group, enterprise: user.enterprise }

    def get_settings(group_id = -1)
      get :settings, id: group_id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_settings(group.id) }

      context 'with incorrect group' do
      end

      context 'with group user can\'t manage' do
      end

      context 'with group user can manage' do
        let(:group) { create :group, enterprise: user.enterprise, owner: user }

        it 'return success' do
          expect(response).to be_success
        end
      end
    end

    context 'without logged user' do
      before { get_settings }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'Budgeting' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:group) { FactoryGirl.create(:group, enterprise: user.enterprise) }
    let!(:budget) { FactoryGirl.create(:approved_budget, subject: group) }

    describe 'GET #plan_overview' do
      def get_plan_overview
        get :plan_overview
      end

      context 'with logged user' do
        let!(:foreign_group) { FactoryGirl.create :group }

        login_user_from_let

        before { get_plan_overview }

        it 'return success' do
          expect(response).to be_success
        end

        it 'shows groups from correct enterprise' do
          groups = assigns(:groups)

          expect(groups).to include group
          expect(groups).to_not include foreign_group
        end
      end

      context 'without logged user' do
        before { get_plan_overview }

        it 'return error' do
          expect(response).to_not be_success
        end
      end
    end

    describe 'GET #view_budget' do
      def get_view_budget
        get :view_budget, id: budget.subject.id, budget_id: budget.id
      end

      context 'with logged user' do
        login_user_from_let

        before { get_view_budget }

        it 'return success' do
          expect(response).to be_success
        end
      end

      context 'without logged user' do
        before { get_view_budget }

        it 'return error' do
          expect(response).to_not be_success
        end
      end
    end

    describe 'GET #request_budget' do
      def get_request_budget(group_id = -1)
        get :request_budget, id: group_id
      end

      let!(:user) { FactoryGirl.create(:user) }
      let!(:group) { FactoryGirl.create(:group, enterprise: user.enterprise) }

      context 'with logged user' do
        login_user_from_let

        before { get_request_budget(group.id) }

        it 'return success' do
          expect(response).to be_success
        end
      end

      context 'without logged user' do
        before { get_request_budget(group.id) }

        it 'return error' do
          expect(response).to_not be_success
        end
      end
    end

    describe 'POST #submit_budget' do
      def post_submit_budget(budget_params = {})
        post :submit_budget, id: group.id, budget: budget_params
      end

      context 'with logged user' do
        login_user_from_let

        context 'with correct params' do
          let(:budget_params) { FactoryGirl.attributes_for(:budget) }

          it 'redirects to correct action' do
            post_submit_budget(budget_params)

            expect(response).to redirect_to action: :budgets
          end

          it 'creates new budget' do
            expect{
              post_submit_budget(budget_params)
            }.to change(Budget,:count).by(1)
          end
        end

        context 'with incorrect params' do
          xit 'redirects to correct action' do
          end

          xit 'does not create new budget' do
            expect{
              post_submit_budget
            }.to_not change(Budget,:count)
          end
        end
      end

      context 'without logged user' do
        before { post_submit_budget }

        it 'return error' do
          expect(response).to_not be_success
        end
      end
    end

    describe 'POST #approve_budget' do
    end

    describe 'POST #decline_budget' do
    end
  end
end
