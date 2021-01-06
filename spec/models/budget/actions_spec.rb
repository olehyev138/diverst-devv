require 'rails_helper'

RSpec.describe Budget::Actions, type: :model do
  describe 'base_includes' do
    let(:base_includes) { [:approver, :requester, :budget_items] }
    it { expect(Budget.base_includes(Request.create_request(nil))).to eq base_includes }
  end

  describe 'approval_blocker' do
    context 'no annual budget' do
      let!(:temp_budget) { create(:budget) }
      let!(:budget) { Budget.with_expenses.find(temp_budget.id) }
      it 'returns error message if annual_budget is not set' do
        expect(budget.approval_blocker).to eq 'Please set an annual budget for this group'
      end
    end

    context 'closed annual budget' do
      let!(:annual_budget) { create(:annual_budget, amount: 100, closed: true) }
      let!(:temp_budget) { create(:budget, annual_budget: annual_budget) }
      let!(:budget) { Budget.with_expenses.find(temp_budget.id) }
      it 'returns error message if annual_budget is closed' do
        expect(budget.approval_blocker).to eq 'Annual Budget is Closed'
      end
    end

    context 'budget exceeds the annual budget' do
      let!(:annual_budget) { create(:annual_budget, amount: 100, closed: false) }
      let!(:temp_budget) { create(:budget, annual_budget: annual_budget, budget_items: build_list(:budget_item, 1, estimated_amount: 101)) }
      let!(:budget) { Budget.with_expenses.find(temp_budget.id) }
      it 'it returns error message if budget exceeds the annual budget' do
        expect(budget.approval_blocker).to eq 'This budget exceeds the annual budget'
      end
    end

    context 'budget equals annual budget' do
      let!(:annual_budget) { create(:annual_budget, amount: 100, closed: false) }
      let!(:temp_budget) { create(:budget, annual_budget: annual_budget, budget_items: build_list(:budget_item, 1, estimated_amount: 100)) }
      let!(:budget) { Budget.with_expenses.find(temp_budget.id) }
      it 'it returns true if budget is exactly the annual budget' do
        expect(budget.approval_blocker).to eq nil
      end
    end

    context 'budget item estimate is 0' do
      let!(:annual_budget) { create(:annual_budget, amount: 100, closed: false) }
      let!(:temp_budget) { create(:budget, annual_budget: annual_budget, budget_items: build_list(:budget_item, 1, estimated_amount: 0)) }
      let!(:budget) { Budget.with_expenses.find(temp_budget.id) }
      it 'returns nil' do
        expect(budget.approval_blocker).to eq nil
      end
    end
  end

  describe 'approve' do
    let!(:approver) { create(:user) }
    let!(:temp_budget) { create(:budget, requester: create(:user), budget_items: build_list(:budget_item, 3, estimated_amount: 0)) }
    let!(:budget) { Budget.with_expenses.find(temp_budget.id) }

    it 'raises an exception' do
      expect { budget.approve(approver) }.to raise_error(InvalidInputException)
    end

    it 'approves budget' do
      budget.annual_budget.update(amount: 100, closed: false)
      budget.budget_items.update_all(estimated_amount: 0)
      expect(budget.approve(approver).is_approved).to eq true
    end

    it 'sends email' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        BudgetMailer.budget_approved(budget).deliver_later
      }.to have_enqueued_job.on_queue('mailers')
    end
  end

  describe 'decline' do
    let!(:approver) { create(:user) }
    let!(:budget) { create(:budget, is_approved: true) }
    before do
      budget.decline(approver)
    end

    it 'declines the budget' do
      expect(budget.is_approved).to eq false
    end

    it 'declines budget_items' do
      budget.budget_items.reload.each do | item |
        expect(item.is_done).to eq true
      end
    end

    it 'sends email' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        BudgetMailer.budget_declined(budget).deliver_later
      }.to have_enqueued_job.on_queue('mailers')
    end
  end
end
