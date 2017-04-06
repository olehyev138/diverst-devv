require 'rails_helper'

RSpec.describe BudgetManager do
  let(:user){ create(:user) }
  let!(:budget){ create(:budget, is_approved: nil, requester: user, approver: nil) }
  let!(:budget_item){ create(:budget_item, budget: budget, estimated_amount: 100, available_amount: 0) }
  let(:budget_manager){ BudgetManager.new(budget) }

  describe "#approve" do
    before(:each){ budget_manager.approve(user) }

    it "updates all budget_items as approved" do
      budget_item.reload
      expect(budget_item.available_amount).to eq 100
    end

    it "updates budget as approved" do
      expect(budget.is_approved).to be_truthy
    end

    it "updates who approves the budget" do
      expect(budget.approver).to eq user
    end

    it "sends an email to requester" do
      mailer = double("BudgetMailer")
      expect(BudgetMailer).to receive(:budget_approved).with(budget){ mailer }
      expect(mailer).to receive(:deliver_later)
      budget_manager.approve(user)
    end
  end

  describe "#decline" do
    before(:each){ budget_manager.decline(user) }

    it "updates budget as declined" do
      expect(budget.is_approved).to be_falsy
    end

    it "updates who declines the budget" do
      expect(budget.approver).to eq user
    end

    it "sends an email to requester" do
      mailer = double("BudgetMailer")
      expect(BudgetMailer).to receive(:budget_declined).with(budget){ mailer }
      expect(mailer).to receive(:deliver_later)
      budget_manager.decline(user)
    end
  end
end
