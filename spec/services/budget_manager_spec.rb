require 'rails_helper'

RSpec.describe BudgetManager, type: :service do
  let(:user) { create(:user) }
  let!(:budget) { create(:budget, is_approved: nil, requester: user, approver: nil) }
  let!(:budget_item) { create(:budget_item, budget: budget, estimated_amount: 100, available_amount: 0) }

  describe '#approve' do
    before(:each) { budget.approve(user) }

    it 'updates all budget_items as approved' do
      budget_item.reload
      expect(budget_item.available_amount).to eq 100
    end

    it 'updates budget as approved' do
      expect(budget.is_approved).to be_truthy
    end

    it 'updates who approves the budget' do
      expect(budget.approver).to eq user
    end

    it 'sends an email to requester' do
      mailer = double('BudgetMailer')

      allow(BudgetMailer).to receive(:budget_approved).with(budget) { mailer }
      allow(mailer).to receive(:deliver_later)

      budget.approve(user)

      expect(mailer).to have_received(:deliver_later).at_least(:once)
    end
  end

  describe '#decline' do
    before(:each) { budget.decline(user) }

    it 'updates budget as declined' do
      expect(budget.is_approved).to be_falsy
    end

    it 'updates who declines the budget' do
      expect(budget.approver).to eq user
    end

    it 'sends an email to requester' do
      mailer = double('BudgetMailer')

      allow(BudgetMailer).to receive(:budget_declined).with(budget) { mailer }
      allow(mailer).to receive(:deliver_later)

      budget.decline(user)

      expect(mailer).to have_received(:deliver_later).at_least(:once)
    end
  end
end
