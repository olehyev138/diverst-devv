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

  describe 'POST #create' do
    def post_create(params={a: 1})
      post :create, group: params
    end

    context 'with logged in user' do
      let(:user) { create :user }
      let(:group_attrs) { attributes_for :group }

      login_user_from_let

      context 'with correct params' do
        it 'creates group' do
          expect{
            post_create(group_attrs)
          }.to change(Group, :count).by(1)
        end

        it 'creates correct group' do
          post_create(group_attrs)

          new_group = Group.last

          expect(new_group.enterprise).to eq user.enterprise
          expect(new_group.name).to eq group_attrs[:name]
          expect(new_group.created_at).to be_within(100).of Time.now.in_time_zone
          expect(new_group.owner).to eq user
        end

        it 'redirects to correct action' do
          post_create(group_attrs)
          expect(response).to redirect_to action: :index
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            expect{
              post_create(group_attrs)
            }.to change(PublicActivity::Activity, :count).by(1)
          end

          describe 'activity record' do
            let(:model) { Group.last }
            let(:owner) { user }
            let(:key) { 'group.create' }

            before {
              post_create(group_attrs)
            }

            include_examples'correct public activity'
          end
        end
      end

      context 'with incorrect params' do
        it 'does not save the new group' do
          expect{ post_create() }
            .to_not change(Group, :count)
        end

        it 'renders new view' do
          post_create
          expect(response).to render_template :new
        end

        it 'shows error' do
          post_create
          group = assigns(:group)

          expect(group.errors).to_not be_empty
        end
      end
    end

    context 'without logged in user' do
      before { post_create }

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

    describe 'GET #edit_annual_budget' do
      let(:user) { create :user }
      let(:group) { create :group, enterprise: user.enterprise }

      def get_edit_annual_budget(group_id=-1)
        get :edit_annual_budget, id: group_id
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
      it 'should be implemented'
    end

    describe 'POST #decline_budget' do
      it 'should be implemented'
    end
  end
end
