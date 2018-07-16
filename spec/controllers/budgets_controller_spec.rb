require 'rails_helper'

RSpec.describe BudgetsController, type: :controller do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group, enterprise: user.enterprise, :annual_budget => 100000) }
  let!(:budget) { FactoryGirl.create(:approved_budget, subject: group) }

  describe 'GET#index' do
    context 'with logged user' do
      let!(:budget1) { create(:approved_budget, subject: group) }
      let!(:budget2) { create(:approved_budget, subject: group) }
      login_user_from_let
      before { get :index, group_id: budget.subject.id }

      it "renders index template" do
        expect(response).to render_template(:index)
      end

      it "returns a valid group object" do
        expect(assigns[:group]).to be_valid
      end

      it 'returns budgest in descending order of id' do
        expect(assigns[:budgets]).to eq [budget2, budget1, budget]
      end
    end

    context "without logged user" do
      before { get :index, group_id: budget.subject.id }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end

  describe 'GET#show' do
    context 'with logged user' do
      login_user_from_let
      before { get :show, group_id: budget.subject.id, id: budget.id }

      it "render show template" do
        expect(response).to render_template :show
      end

      it "returns a valid group object" do
        expect(assigns[:group]).to be_valid
      end
    end

    context 'without logged user' do
      before { get :show, group_id: budget.subject.id, id: budget.id }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end

  describe 'GET#new' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:group) { FactoryGirl.create(:group, enterprise: user.enterprise) }

    context 'with logged user' do
      login_user_from_let

      before { get :new, group_id: group.id }

      it "returns a valid group object" do
        expect(assigns[:group]).to be_valid
      end

      it "return a new Budget object" do
        expect(assigns[:budget]).to be_a_new(Budget)
      end

      it "render new template" do
        expect(response).to render_template :new
      end
    end

    context 'without logged user' do
      before { get :new, group_id: group.id }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end

  describe 'POST#create' do
    context 'with logged user' do
      login_user_from_let

      context 'with correct params' do
        let(:budget_params) { FactoryGirl.attributes_for(:budget) }

        it "returns a valid group object" do
          post :create, group_id: group.id, budget: budget_params
          expect(assigns[:group]).to be_valid
        end

        it 'redirects to correct action' do
          post :create, group_id: group.id, budget: budget_params
          expect(response).to redirect_to action: :index
        end

        it 'creates new budget' do
          expect{
            post :create, group_id: group.id, budget: budget_params
          }.to change(Budget,:count).by(1)
        end

        it "flashes a notice message" do
          post :create, group_id: group.id, budget: budget_params
          expect(flash[:notice]).to eq "Your budget was created"
        end
      end

      context 'with invalid params' do
        it "flashes a notice message" do
          post :create, group_id: group.id, budget: {}
          expect(flash[:alert]).to eq "param is missing or the value is empty: budget"
        end

        it "flashes a notice message" do
          allow_any_instance_of(Group).to receive(:save).and_return(false)
          post :create, group_id: group.id, budget: {subject: nil}
          expect(flash[:alert]).to eq "Your budget was not created. Please fix the errors"
        end
      end
    end

    context 'without logged user' do
      before { post :create, group_id: group.id, budget: {} }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end

  describe 'POST#approve' do
    context 'with logged user' do
      login_user_from_let

      before do
        post :approve, group_id: budget.subject.id, budget_id: budget.id, budget: { comments: "here is a comment" }
        budget.reload
      end

      it "returns a valid group object" do
        expect(assigns[:budget]).to be_valid
      end

      it 'redirects to index' do
        expect(response).to redirect_to action: :index
      end

      it "budget is approved" do
        expect(budget.is_approved).to eq true
      end
      
      it "saves the comment" do
        expect(budget.comments).to eq "here is a comment"
      end
    end

    context "without a logged in user" do
      before { post :approve, group_id: budget.subject.id, budget_id: budget.id}
      it_behaves_like "redirect user to users/sign_in path"
    end
  end

  describe 'POST#decline' do
    context 'with logged user' do
      login_user_from_let

      before do
        post :decline, group_id: budget.subject.id, budget_id: budget.id, budget: { comments: "here is a comment" }
        budget.reload
      end

      it "returns a valid group object" do
        expect(assigns[:budget]).to be_valid
      end

      it 'redirects to index' do
        expect(response).to redirect_to action: :index
      end

      it "budget is declined" do
        expect(budget.is_approved).to eq false
      end
      
      it "saves the comment" do
        expect(budget.comments).to eq "here is a comment"
      end
    end

    context "without a logged in user" do
      before do
        post :decline, group_id: budget.subject.id, budget_id: budget.id
        BudgetManager.new(budget).decline(user)
      end

      it_behaves_like "redirect user to users/sign_in path"
    end
  end

  describe 'DELETE#destroy' do
    context 'with logged user' do
      login_user_from_let
        context "with valid destroy" do
          it 'removes a budget' do
            expect{ delete :destroy, group_id: budget.subject.id, id: budget.id }.to change(Budget, :count).by(-1)
          end

          it 'flashes a notice message' do
            delete :destroy, group_id: budget.subject.id, id: budget.id
            expect(flash[:notice]).to eq 'Your budget was deleted'
          end

          it 'redirects to index action' do
            delete :destroy, group_id: budget.subject.id, id: budget.id
            expect(response).to redirect_to action: :index
          end
        end

        context "with invalid destroy" do
          before {
            request.env["HTTP_REFERER"] = "back"
            allow_any_instance_of(Budget).to receive(:destroy).and_return(false)
            delete :destroy, group_id: budget.subject.id, id: budget.id
          }

          it 'flashes an alert' do
            expect(flash[:alert]).to eq "Your budget was not deleted. Please fix the errors"
          end

          it 'redirects to index action' do
            expect(response).to redirect_to "back"
          end
        end
    end

     context "without a logged in user" do
        before {  delete :destroy, group_id: budget.subject.id, id: budget.id }
        it_behaves_like "redirect user to users/sign_in path"
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

      it 'returns group.enterprise object' do
        expect(assigns[:group].enterprise).to eq group.enterprise
      end

      it "renders edit_annual_budget template" do
        expect(response).to render_template :edit_annual_budget
      end
    end

    context 'without logged user' do
      before { get_edit_annual_budget }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end


  describe 'put#reset_annual_budget' do
    context 'with logged user' do
      login_user_from_let
        context "with valid update"do

          before {
            request.env["HTTP_REFERER"] = "back"
            put :reset_annual_budget, group_id: budget.subject.id, id: budget.id
          }

          it 'set annual_budget and leftover_money to zero' do
            expect(assigns[:group].annual_budget).to eq 0
            expect(assigns[:group].leftover_money).to eq 0
          end

          it "sets 'is_approved' attribute to false for all budgets belonging to group" do
            expect(assigns[:group].budgets).to all(have_attributes(:is_approved => false))
          end

          describe 'public activity' do
            enable_public_activity

            it 'creates public activity record' do
              expect{
                put :reset_annual_budget, group_id: budget.subject.id, id: budget.id
                }.to change(PublicActivity::Activity, :count).by(1)
            end

            describe 'activity record' do
              let(:model) { Group.last }
              let(:owner) { user }
              let(:key) { 'group.annual_budget_update' }

              before {
                put :reset_annual_budget, group_id: budget.subject.id, id: budget.id
              }

              include_examples'correct public activity'
            end
          end

          it 'flashes a notice message' do
            expect(flash[:notice]).to eq "Your budget was updated"
          end

          it 'redirects to back' do
            expect(response).to redirect_to "back"
          end
        end

        context "with invalid update" do
          before {
            allow_any_instance_of(Group).to receive(:update).and_return(false)
            request.env["HTTP_REFERER"] = "back"
            put :reset_annual_budget, group_id: budget.subject.id, id: budget.id
          }

          it 'flashes an alert message' do
            expect(flash[:alert]).to eq "Your budget was not updated. Please fix the errors"
          end

          it 'redirects to back' do
            expect(response).to redirect_to "back"
          end
        end
    end
  end


  describe 'put#carry_over_annual_budget' do
    context 'with logged user' do
      login_user_from_let
        context "with valid update"do

          before {
            request.env["HTTP_REFERER"] = "back"
            put :carry_over_annual_budget, group_id: budget.subject.id, id: budget.id
          }

          it 'set leftover_money to and zero annual_budget to 100000' do
            expect(assigns[:group].annual_budget).to eq 100000
            expect(assigns[:group].leftover_money).to eq 0
          end

          it "sets 'is_approved' attribute to false for all budgets belonging to group" do
            expect(assigns[:group].budgets).to all(have_attributes(:is_approved => false))
          end

          describe 'public activity' do
            enable_public_activity

            it 'creates public activity record' do
              expect{
                put :carry_over_annual_budget, group_id: budget.subject.id, id: budget.id
                }.to change(PublicActivity::Activity, :count).by(1)
            end

            describe 'activity record' do
              let(:model) { Group.last }
              let(:owner) { user }
              let(:key) { 'group.annual_budget_update' }

              before {
                put :carry_over_annual_budget, group_id: budget.subject.id, id: budget.id
              }

              include_examples'correct public activity'
            end
          end

          it 'flashes a notice message' do
            expect(flash[:notice]).to eq "Your budget was updated"
          end

          it 'redirects to back' do
            expect(response).to redirect_to "back"
          end
        end

        context "with invalid update" do
          before {
            allow_any_instance_of(Group).to receive(:update).and_return(false)
            request.env["HTTP_REFERER"] = "back"
            put :carry_over_annual_budget, group_id: budget.subject.id, id: budget.id
          }

          it 'flashes an alert message' do
            expect(flash[:alert]).to eq "Your budget was not updated. Please fix the errors"
          end

          it 'redirects to back' do
            expect(response).to redirect_to "back"
          end
        end
    end
  end


  describe 'POST #update_annual_budget' do
    def post_update_annual_budget(group_id = -1, params = {})
      request.env["HTTP_REFERER"] = "back"
      post :update_annual_budget, group_id: group_id, group: params
    end

    let(:user) { create :user }
    let(:group) { create :group, enterprise: user.enterprise, annual_budget: annual_budget }

    let(:annual_budget) { rand(1..100) }
    let(:new_annual_budget) { rand(101..200) } #new range so it does not intersect with old value range

    context 'with logged in user' do
      login_user_from_let

      context 'with correct params' do
        before do
          post_update_annual_budget(group.id, {annual_budget: new_annual_budget})
        end

        it "returns a valid enterprise object" do
          expect(assigns[:group].enterprise).to be_valid
        end

        it 'updates group annual budget' do
          expect(group.reload.annual_budget).to eq new_annual_budget
        end

        it 'redirects to correct path' do
          expect(response).to redirect_to "back"
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

        it 'flashes a notice message' do
          expect(flash[:notice]).to eq 'Your budget was updated'
        end
      end

      context 'with invalid update' do
        before do
          allow_any_instance_of(Group).to receive(:update).and_return(false)
          post_update_annual_budget(group.id, {annual_budget: new_annual_budget})
        end

        it 'redirects to correct path' do
          expect(response).to redirect_to "back"
        end

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq "Your budget was not updated. Please fix the errors"
        end
      end
    end

    context 'without logged user' do
      before { post_update_annual_budget(group.id, {annual_budget: new_annual_budget}) }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end
end
