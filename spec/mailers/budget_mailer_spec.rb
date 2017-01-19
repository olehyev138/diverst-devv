require 'rails_helper'

RSpec.describe BudgetMailer, type: :mailer do
  describe '#approve_request' do
    let(:user) { create :user }
    let(:budget) { create :budget }
    let(:group) { budget.subject }
    let(:view_budget_url) { view_budget_group_url(group, budget_id: budget.id) }

    let(:mail) { described_class.approve_request(budget, user).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to include(group.name)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@diverst.com'])
    end

    it 'assigns @name' do
      expect(mail.body.encoded).to include(user.name)
    end

    it 'assigns @confirmation_url' do
      expect(mail.body.encoded)
        .to include(view_budget_url)
    end
  end
end
