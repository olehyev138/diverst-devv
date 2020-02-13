require 'rails_helper'

RSpec.describe BudgetsController, type: :controller do
  include ActiveJob::TestHelper

  let!(:user) { create(:user) }
  let!(:group) { create(:group, enterprise: user.enterprise, annual_budget: 100000) }
  let!(:annual_budget) { create(:annual_budget, group_id: group.id, amount: group.annual_budget, enterprise_id: user.enterprise_id) }
  let!(:budget) { create(:approved_budget, group: group, annual_budget_id: annual_budget.id) }

  describe 'GET#index' do
    context 'with logged user' do
      let!(:budget1) { create(:approved_budget, group: group, annual_budget_id: annual_budget.id) }
      let!(:budget2) { create(:approved_budget, group: group, annual_budget_id: annual_budget.id) }
      login_user_from_let
      before { get :index, group_id: budget.group.id, annual_budget_id: annual_budget.id }

      it 'renders index template' do
        expect(response).to render_template(:index)
      end

      it 'returns a valid group object' do
        expect(assigns[:group]).to be_valid
      end

      it 'returns budgest in descending order of id' do
        expect(assigns[:budgets]).to eq [budget2, budget1, budget]
      end
    end

    context 'without logged user' do
      before { get :index, group_id: budget.group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#show' do
    context 'with logged user' do
      login_user_from_let
      before { get :show, group_id: budget.group.id, id: budget.id }

      it 'render show template' do
        expect(response).to render_template :show
      end

      it 'returns a valid group object' do
        expect(assigns[:group]).to be_valid
      end
    end

    context 'without logged user' do
      before { get :show, group_id: budget.group.id, id: budget.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#new' do
    context 'with logged user' do
      login_user_from_let

      context 'with annual budget set' do
        before { get :new, group_id: group.id, annual_budget_id: annual_budget.id }

        it 'returns a valid group object' do
          expect(assigns[:group]).to be_valid
        end

        it 'return a new Budget object' do
          expect(assigns[:budget]).to be_a_new(Budget)
        end

        it 'render new template' do
          expect(response).to render_template :new
        end
      end

      context 'with no annual budget set' do
        let!(:another_group) { create(:group, enterprise: user.enterprise) }
        let!(:another_annual_budget) { create(:annual_budget, group_id: another_group.id, amount: another_group.annual_budget, enterprise_id: user.enterprise_id) }

        before do
          request.env['HTTP_REFERER'] = 'back'
          get :new, group_id: another_group.id, annual_budget_id: another_annual_budget.id
        end

        it 'redirects to previous page' do
          expect(response).to redirect_to 'back'
        end

        it 'displays flash alert message' do
          expect(flash[:alert]).to eq 'Annual Budget is not set for this group. Please check back later.'
        end
      end
    end

    context 'without logged user' do
      before { get :new, group_id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#export_csv' do
    context 'when user is logged in' do
      login_user_from_let
      before {
        allow(GroupBudgetsDownloadJob).to receive(:perform_later)
        request.env['HTTP_REFERER'] = 'back'
        get :export_csv, group_id: group.id
      }

      it 'returns to previous page' do
        expect(response).to redirect_to 'back'
      end

      it 'flashes' do
        expect(flash[:notice]).to eq 'Please check your Secure Downloads section in a couple of minutes'
      end

      it 'calls job' do
        expect(GroupBudgetsDownloadJob).to have_received(:perform_later)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { get :export_csv, group_id: group.id }.to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { group }
          let(:owner) { user }
          let(:key) { 'group.export_budgets' }

          before {
            perform_enqueued_jobs do
              get :export_csv, group_id: group.id
            end
          }

          include_examples 'correct public activity'
        end
      end
    end

    context 'when user is not logged in' do
      before { get :export_csv, group_id: group.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#create' do
    context 'with logged user' do
      login_user_from_let

      context 'with correct params' do
        let(:budget_params) { attributes_for(:budget) }

        it 'returns a valid group object' do
          post :create, group_id: group.id, budget: budget_params
          expect(assigns[:group]).to be_valid
        end

        it 'redirects to correct action' do
          post :create, group_id: group.id, budget: budget_params
          expect(response).to redirect_to action: :index
        end

        it 'creates new budget' do
          expect {
            post :create, group_id: group.id, budget: budget_params
          }.to change(Budget, :count).by(1)
        end

        it 'flashes a notice message' do
          post :create, group_id: group.id, budget: budget_params
          expect(flash[:notice]).to eq 'Your budget was created'
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { post :create, group_id: group.id, budget: budget_params }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { Budget.last }
            let(:owner) { user }
            let(:key) { 'budget.create' }

            before {
              perform_enqueued_jobs do
                post :create, group_id: group.id, budget: budget_params
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'with invalid params' do
        it 'flashes a notice message' do
          post :create, group_id: group.id, budget: {}
          expect(flash[:alert]).to eq 'param is missing or the value is empty: budget'
        end

        it 'flashes a notice message' do
          allow_any_instance_of(Group).to receive(:save).and_return(false)
          post :create, group_id: group.id, budget: { group: nil }
          expect(flash[:alert]).to eq 'Your budget was not created. Please fix the errors'
        end
      end
    end

    context 'without logged user' do
      before { post :create, group_id: group.id, budget: {} }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#approve' do
    context 'with logged user' do
      login_user_from_let

      let(:approve) do
        post :approve, group_id: budget.group.id, budget_id: budget.id, budget: { comments: 'here is a comment' }
        budget.reload
      end

      it 'returns a valid group object' do
        approve
        expect(assigns[:budget]).to be_valid
      end

      it 'redirects to index' do
        approve
        expect(response).to redirect_to action: :index
      end

      it 'budget is approved' do
        approve
        expect(budget.is_approved).to eq true
      end

      it 'saves the comment' do
        approve
        expect(budget.comments).to eq 'here is a comment'
      end

      context 'when user tries to approve budget request when annual budget is not set' do
        before do
          group.update(annual_budget: 0)
          annual_budget.update(amount: 0)
          request.env['HTTP_REFERER'] = 'back'
          approve
        end

        it 'displays flash alert message' do
          expect(flash[:alert]).to eq 'please set an annual budget for this group'
        end

        it 'redirect to previous page' do
          expect(response).to redirect_to 'back'
        end
      end

      context 'when user tries to approve budget greater than annual budget' do
        let!(:budget) { create(:budget, group_id: group.id, annual_budget_id: annual_budget.id) }
        before do
          group.update(annual_budget: 10)
          annual_budget.update(amount: 10)
          request.env['HTTP_REFERER'] = 'back'
          approve
        end

        it 'does not approve budget' do
          expect(budget.is_approved?).to eq false
        end

        it 'displays flash alert message' do
          expect(flash[:alert]).to eq "This budget exceeds the annual budget of #{ActionController::Base.helpers.number_to_currency(budget.annual_budget.amount)} and therefore cannot be approved"
        end

        it 'redirect to previous page' do
          expect(response).to redirect_to 'back'
        end
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { approve }
            .to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { budget }
          let(:owner) { user }
          let(:key) { 'budget.approve' }

          before {
            perform_enqueued_jobs do
              approve
            end
          }

          include_examples 'correct public activity'
        end
      end
    end

    context 'without a logged in user' do
      before { post :approve, group_id: budget.group.id, budget_id: budget.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#decline' do
    context 'with logged user' do
      login_user_from_let
      let(:decline) do
        post :decline, group_id: budget.group.id, budget_id: budget.id
        budget.reload
      end

      it 'returns a valid group object' do
        decline
        expect(assigns[:budget]).to be_valid
      end

      it 'redirects to index' do
        decline
        expect(response).to redirect_to action: :index
      end

      it 'budget is declined' do
        decline
        expect(budget.is_approved).to eq false
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { decline }
            .to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { budget }
          let(:owner) { user }
          let(:key) { 'budget.decline' }

          before {
            perform_enqueued_jobs do
              decline
            end
          }

          include_examples 'correct public activity'
        end
      end
    end

    context 'without a logged in user' do
      before do
        post :decline, group_id: budget.group.id, budget_id: budget.id
        BudgetManager.new(budget).decline(user)
      end

      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'DELETE#destroy' do
    context 'with logged user' do
      login_user_from_let
      context 'with valid destroy' do
        it 'removes a budget' do
          expect { delete :destroy, group_id: budget.group.id, id: budget.id }.to change(Budget, :count).by(-1)
        end

        it 'flashes a notice message' do
          delete :destroy, group_id: budget.group.id, id: budget.id
          expect(flash[:notice]).to eq 'Your budget was deleted'
        end

        it 'redirects to index action' do
          delete :destroy, group_id: budget.group.id, id: budget.id
          expect(response).to redirect_to action: :index
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { delete :destroy, group_id: budget.group.id, id: budget.id }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { budget }
            let(:owner) { user }
            let(:key) { 'budget.destroy' }

            before {
              perform_enqueued_jobs do
                delete :destroy, group_id: budget.group.id, id: budget.id
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'with invalid destroy' do
        before {
          request.env['HTTP_REFERER'] = 'back'
          allow_any_instance_of(Budget).to receive(:destroy).and_return(false)
          delete :destroy, group_id: budget.group.id, id: budget.id
        }

        it 'flashes an alert' do
          expect(flash[:alert]).to eq 'Your budget was not deleted. Please fix the errors'
        end

        it 'redirects to index action' do
          expect(response).to redirect_to 'back'
        end
      end
    end

    context 'without a logged in user' do
      before { delete :destroy, group_id: budget.group.id, id: budget.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#edit_annual_budget' do
    let(:user) { create :user }
    let(:group) { create :group, enterprise: user.enterprise }

    before {
      user.policy_group.groups_manage = true
      user.policy_group.save!
    }

    def get_edit_annual_budget(group_id = -1)
      get :edit_annual_budget, group_id: group_id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_edit_annual_budget(group.id) }

      it 'returns group.enterprise object' do
        expect(assigns[:group].enterprise).to eq group.enterprise
      end

      it 'renders edit_annual_budget template' do
        expect(response).to render_template :edit_annual_budget
      end
    end

    context 'without logged user' do
      before { get_edit_annual_budget }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'put#reset_annual_budget' do
    context 'with logged user' do
      login_user_from_let
      context 'with valid update' do
        let!(:group1) { create(:group, enterprise: user.enterprise, annual_budget: 2000) }
        let!(:annual_budget1) { create(:annual_budget, group_id: group1.id, amount: group1.annual_budget, closed: false, enterprise_id: user.enterprise_id) }
        let!(:budget1) { create(:approved_budget, group_id: group1.id, annual_budget_id: annual_budget1.id, requester_id: user.id, approver_id: user.id) }
        let!(:budget_item) { budget1.budget_items.first }
        let!(:approved_budget) { budget_item.available_amount }
        let!(:initiative) { create(:initiative, owner_group: group1, finished_expenses: false, annual_budget_id: annual_budget1.id,
                                                estimated_funding: approved_budget, budget_item_id: budget_item.id)
        }
        let!(:expense) { create(:initiative_expense, amount: approved_budget / 2, annual_budget_id: annual_budget1.id, initiative_id: initiative.id) }

        context 'when initiatives and budgets are present' do
          before do
            request.env['HTTP_REFERER'] = 'back'
            put :reset_annual_budget, group_id: group1.id
          end

          it 'closes existing annual budget object' do
            annual_budget = assigns[:group].annual_budgets.first
            expect(annual_budget.closed).to eq true
          end

          it 'creates another opened annual budget' do
            annual_budget = assigns[:group].annual_budgets.last
            expect(annual_budget.closed).to eq false
            expect(annual_budget.amount).to eq 0.0
          end
        end

        context 'when no initiatives and no budgets are present' do
          let!(:group2) { create(:group, enterprise: user.enterprise, annual_budget: 2000) }
          before do
            create(:annual_budget, group_id: group2.id, amount: group2.annual_budget, enterprise_id: user.enterprise_id)
            request.env['HTTP_REFERER'] = 'back'
            put :reset_annual_budget, group_id: group2.id
          end

          it 'resets existing annual_budget values to 0' do
            annual_budget = assigns[:group].annual_budgets.last
            expect(annual_budget.amount).to eq 0
            expect(annual_budget.leftover_money).to eq 0
            expect(annual_budget.available_budget).to eq 0
            expect(annual_budget.expenses).to eq 0
          end

          it 'flashes a notice message' do
            expect(flash[:notice]).to eq 'Your budget was updated'
          end

          it 'redirects to back' do
            expect(response).to redirect_to 'back'
          end
        end

        describe 'public activity' do
          let!(:group2) { create(:group, enterprise: user.enterprise, annual_budget: 2000) }
          before do
            create(:annual_budget, group_id: group2.id, amount: group2.annual_budget, enterprise_id: user.enterprise_id)
            request.env['HTTP_REFERER'] = 'back'
          end
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { put :reset_annual_budget, group_id: group2.id }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { group2 }
            let(:owner) { user }
            let(:key) { 'group.annual_budget_update' }

            before {
              perform_enqueued_jobs do
                put :reset_annual_budget, group_id: group2.id
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'with invalid update' do
        let!(:group1) { create(:group, enterprise: user.enterprise, annual_budget: 2000) }
        let!(:annual_budget1) { create(:annual_budget, group_id: group1.id, amount: group1.annual_budget, closed: false, enterprise_id: user.enterprise_id) }
        let!(:budget1) { create(:approved_budget, group_id: group1.id, annual_budget_id: annual_budget1.id, requester_id: user.id, approver_id: user.id) }
        let!(:budget_item) { budget1.budget_items.first }
        let!(:approved_budget) { budget_item.available_amount }
        let!(:initiative) { create(:initiative, owner_group: group1, finished_expenses: false, annual_budget_id: annual_budget1.id,
                                                estimated_funding: approved_budget, budget_item_id: budget_item.id)
        }
        let!(:expense) { create(:initiative_expense, amount: approved_budget / 2, annual_budget_id: annual_budget1.id, initiative_id: initiative.id) }


        before do
          allow_any_instance_of(Group).to receive(:update).and_return(false)
          request.env['HTTP_REFERER'] = 'back'
          put :reset_annual_budget, group_id: group1.id
        end

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your budget was not updated.'
        end

        it 'redirects to back' do
          expect(response).to redirect_to 'back'
        end
      end
    end
  end

  describe 'put#carry_over_annual_budget' do
    context 'with logged user' do
      let!(:group1) { create(:group, enterprise: user.enterprise, annual_budget: 2000) }
      let!(:annual_budget1) { create(:annual_budget, group_id: group1.id, amount: group.annual_budget, closed: false, enterprise_id: user.enterprise_id) }
      let!(:budget1) { create(:budget, group_id: group1.id, is_approved: true, approver_id: user.id, requester_id: user.id,
                                       annual_budget_id: annual_budget1.id)
      }
      let!(:budget_item) { budget1.budget_items.first }
      let!(:approved_budget) { budget_item.available_amount }
      let!(:initiative) { create(:initiative, owner_group: group1, finished_expenses: false, annual_budget_id: annual_budget1.id,
                                              estimated_funding: approved_budget, budget_item_id: budget_item.id)
      }
      let!(:expense) do
        BudgetManager.new(budget1).approve(user)
        create(:initiative_expense, amount: approved_budget / 2, annual_budget_id: annual_budget1.id, initiative_id: initiative.id, owner_id: user.id)
        initiative.update estimated_funding: budget1.budget_items.last.estimated_amount, budget_item_id: budget1.budget_items.last.id
      end

      login_user_from_let

      context 'with valid update' do
        context 'when leftover_money is zero' do
          let!(:another_group) { create(:group, enterprise: user.enterprise) }

          before do
            request.env['HTTP_REFERER'] = 'back'
            put :carry_over_annual_budget, group_id: another_group.id
          end

          it 'displays a flash alert message' do
            expect(flash[:alert]).to eq 'Your budget was not updated.'
          end

          it 'redirects to previous page' do
            expect(response).to redirect_to 'back'
          end
        end

        context 'with leftover_money' do
          before do
            initiative.finish_expenses!
            request.env['HTTP_REFERER'] = 'back'
          end

          describe 'public activity' do
            enable_public_activity

            it 'creates public activity record' do
              perform_enqueued_jobs do
                expect { put :carry_over_annual_budget, group_id: group1.id }
                .to change(PublicActivity::Activity, :count).by(1)
              end
            end

            describe 'activity record' do
              let(:model) { group1 }
              let(:owner) { user }
              let(:key) { 'group.annual_budget_update' }

              before do
                perform_enqueued_jobs do
                  put :carry_over_annual_budget, group_id: group1.id
                end
              end

              include_examples 'correct public activity'
            end
          end

          it 'flashes a notice message' do
            put :carry_over_annual_budget, group_id: group1.id
            expect(flash[:notice]).to eq 'Your budget was updated'
          end

          it 'redirects to back' do
            put :carry_over_annual_budget, group_id: group1.id
            expect(response).to redirect_to 'back'
          end
        end
      end

      context 'with invalid update' do
        before {
          allow_any_instance_of(Group).to receive(:update).and_return(false)
          request.env['HTTP_REFERER'] = 'back'
          put :carry_over_annual_budget, group_id: group1.id
        }

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your budget was not updated.'
        end

        it 'redirects to back' do
          expect(response).to redirect_to 'back'
        end
      end
    end
  end

  describe 'POST #update_annual_budget' do
    def post_update_annual_budget(group_id = -1, params = {})
      request.env['HTTP_REFERER'] = 'back'
      post :update_annual_budget, group_id: group_id, group: params
    end

    context 'with logged in user' do
      login_user_from_let

      context 'with correct params' do
        context 'when group annual budget is updated with 0' do
          let(:zero_annual_budget) { 0 }

          before { post_update_annual_budget(group.id, { annual_budget: zero_annual_budget }) }

          it 'redirects to previous page' do
            expect(response).to redirect_to 'back'
          end

          it 'displays a flash alert message' do
            expect(flash[:alert]).to eq 'Your budget was not updated.'
          end
        end

        context 'when group annual budget is updated with empty params' do
          let!(:group_annual_budget) { group.annual_budget }
          before { post_update_annual_budget(group.id, {}) }

          it 'group annual budget is unchanged' do
            expect(group.annual_budget).to eq group_annual_budget
            expect(annual_budget.amount).to eq group_annual_budget
          end
        end

        context 'when group annual budget is updated with non-zero value' do
          let!(:group_annual_budget) { group.annual_budget }
          let!(:new_annual_budget) { 800000 }

          before { post_update_annual_budget(group.id, { annual_budget: new_annual_budget }) }

          it 'group annual budget is changed' do
            expect(group.reload.annual_budget).not_to eq group_annual_budget
            expect(group.reload.annual_budget).to eq new_annual_budget

            expect(annual_budget.reload.amount).not_to eq group_annual_budget
            expect(annual_budget.reload.amount).to eq new_annual_budget
          end

          it 'flashes a notice message' do
            expect(flash[:notice]).to eq 'Your budget was updated'
          end

          describe 'public activity' do
            enable_public_activity

            it 'creates public activity record' do
              perform_enqueued_jobs do
                expect {
                  post_update_annual_budget(group.id, { annual_budget: new_annual_budget })
                }.to change(PublicActivity::Activity, :count).by(1)
              end
            end

            describe 'activity record' do
              let(:model) { group }
              let(:owner) { user }
              let(:key) { 'group.annual_budget_update' }

              before {
                perform_enqueued_jobs do
                  post_update_annual_budget(group.id, { annual_budget: new_annual_budget })
                end
              }

              include_examples 'correct public activity'
            end
          end
        end
      end

      context 'with invalid update' do
        let!(:new_annual_budget) { nil }
        before do
          allow_any_instance_of(Group).to receive(:update).and_return(false)
          post_update_annual_budget(group.id, { annual_budget: new_annual_budget })
        end

        it 'redirects to previous path' do
          expect(response).to redirect_to 'back'
        end

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your budget was not updated.'
        end
      end
    end

    context 'without logged user' do
      before { post_update_annual_budget(group.id, { annual_budget: new_annual_budget }) }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
