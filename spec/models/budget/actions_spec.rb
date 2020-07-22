require 'rails_helper'

RSpec.describe Budget::Actions, type: :model do
  describe 'base_includes' do
    it { expect(Budget.base_includes.include?(:budget_items)).to eq true }
  end

  describe 'approval_blocker' do
    let!(:budget) { create(:budget) }

    it 'returns error message if annual_budget is not set' do
      expect(budget.approval_blocker).to eq 'Please set an annual budget for this group'
    end

    it 'returns error message if annual_budget is closed' do
      budget.annual_budget.update(amount: 100, closed: true)
      expect(budget.approval_blocker).to eq 'Annual Budget is Closed'
    end

    it 'it returns error message if budget exceeds the annual budget' do
      budget.annual_budget.update(amount: 100, closed: false)
      budget.budget_items[0].update(estimated_amount: 101)
      expect(budget.approval_blocker).to eq 'This budget exceeds the annual budget'
    end

    it 'returns nil' do
      budget.annual_budget.update(amount: 100, closed: false)
      budget.budget_items.update_all(estimated_amount: 0)
      expect(budget.approval_blocker).to eq nil
    end
  end

  describe 'approve' do
    let!(:approver) { create(:user) }
    let!(:budget) { create(:budget, requester: create(:user)) }

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
    let!(:budget) { create(:budget) }
    before do
      budget.decline(approver)
    end

    it 'declines the budget' do
      expect(budget.is_approved).to eq false
    end

    it 'declines budget_items' do
      budget.budget_items.each do | item |
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
